# Data Source for Latest Ubuntu 24 AMI
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_security_group" "bastion" {
    name        = var.bastion_ec2_security_group_name
    description = var.bastion_ec2_security_group_description
    vpc_id     = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "bastion_http" {
    security_group_id = aws_security_group.bastion.id

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_from_my_ip" {
    security_group_id = aws_security_group.bastion.id

    #cidr_ipv4   = "0.0.0.0/0"
    cidr_ipv4   = var.my_ip
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ping" {
    security_group_id = aws_security_group.bastion.id
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "icmp"
    from_port   = -1  # -1 allows all ICMP types
    to_port     = -1  # -1 allows all ICMP types
}

resource "aws_vpc_security_group_ingress_rule" "bastion_https" {
    security_group_id = aws_security_group.bastion.id
    cidr_ipv4        = "0.0.0.0/0"
    ip_protocol      = "tcp"
    from_port        = 443
    to_port          = 443
}

resource "aws_vpc_security_group_egress_rule" "bastion_outbound" {
    security_group_id = aws_security_group.bastion.id

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = -1

}

# # remove from bastion ???
# resource "aws_vpc_security_group_egress_rule" "bastion_python_outbound" {
#     security_group_id = aws_security_group.bastion.id

#     cidr_ipv4   = "0.0.0.0/0"
#     ip_protocol = "tcp"
#     from_port   = 5000
#     to_port     = 5000
# }

# resource "aws_vpc_security_group_ingress_rule" "bastion_python_inbound" {
#     security_group_id = aws_security_group.bastion.id

#     cidr_ipv4   = "0.0.0.0/0"
#     ip_protocol = "tcp"
#     from_port   = 5000
#     to_port     = 5000
# }

# Bastion Host Configuration
resource "aws_instance" "bastion" {
    #for_each = toset(var.public_subnet_ids)
    #subnet_id      = each.value
    count          = length(var.public_subnet_ids)
    subnet_id = var.public_subnet_ids[count.index]
    ami             = data.aws_ami.ubuntu.id
    instance_type   = var.bastion_ec2_instance_type
    vpc_security_group_ids = [aws_security_group.bastion.id]
    key_name = var.aws_ec2_key
    tags = {
        Name = var.public_tag
       #Subnet  = data.aws_subnet.public_subnet[count.index].tags["Name"]  
       #Subnet  = var.public_subnet_ids[count.index].tags["Name"]
       #how to add subnet name as a tag? 
    }
}

resource "aws_security_group" "app" {
    name        = var.app_ec2_security_group_name
    description = var.app_ec2_security_group_description
    vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
    security_group_id = aws_security_group.app.id

    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.bastion.id  # Allow traffic from Bastion Host
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_app" {
    security_group_id = aws_security_group.app.id

    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.app.id # allow ssh from private ec2 in different subnets
}

resource "aws_vpc_security_group_ingress_rule" "app_flask_from_alb" {
    security_group_id = aws_security_group.app.id

    from_port   = 5000
    to_port     = 5000
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.alb.id  # Allow traffic from alb
}

resource "aws_vpc_security_group_egress_rule" "app_outbound_to_nat" {
    security_group_id = aws_security_group.app.id
    ip_protocol =  -1 # Allow all outbound traffic
    cidr_ipv4 = "0.0.0.0/0"  # NAT Gateway handles outbound internet access aaccording to route table
}

resource "aws_instance" "app" {
    count          = length(var.private_subnet_ids_ec2)
    subnet_id = var.private_subnet_ids_ec2[count.index]
    ami             = data.aws_ami.ubuntu.id
    instance_type   = var.app_ec2_instance_type
    vpc_security_group_ids = [aws_security_group.app.id]
    key_name = var.aws_ec2_key
    user_data = file("install-flask-app.sh")
    tags = {
        Name = var.private_tag
    }
}

resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = var.alb_security_group_description
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" { #should only allow 80 from app sg
    security_group_id = aws_security_group.alb.id

    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
    security_group_id = aws_security_group.alb.id

    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
    security_group_id = aws_security_group.alb.id
    ip_protocol =  -1 # Allow all outbound traffic
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_lb" "this" {
    name               = "flask-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = var.public_subnet_ids  # Subnets for the ALB
    enable_deletion_protection = false  # Optional: Set to true for extra protection

    tags = {
        Name = var.public_tag
    }
}

resource "aws_lb_target_group" "this" {
    name     = var.alb_tg_name
    port     = 5000
    protocol = "HTTP"
    vpc_id   = var.vpc_id  

    health_check {
        interval            = 30
        path                = "/"
        port                = 5000
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 3
        healthy_threshold   = 3
    }

    tags = {
        Name = var.public_tag
    }
}

resource "aws_lb_target_group_attachment" "app_target_group_attachment" {
    count             = length(aws_instance.app)
    target_id         = aws_instance.app[count.index].id
    target_group_arn = aws_lb_target_group.this.arn
    port             = 5000
}

data "aws_acm_certificate" "this" {
    domain   = var.domain_name 
    most_recent = true 
    #status = "ISSUED"
    # │   with module.flask-ec2.data.aws_acm_certificate.this,
    # │   on modules/ec2/main.tf line 242, in data "aws_acm_certificate" "this":
    # │  242:     status = "ISSUED"
    # │ 
    # │ Can't configure a value for "status": its value will be decided automatically based on the result of applying this configuration.
    # ╵
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.this.arn
    port              = 443
    protocol          = "HTTPS"

    # Use the certificate ARN from the ACM data source
    certificate_arn   = data.aws_acm_certificate.this.arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this.arn
    }
}

# resource "aws_lb_listener" "http" {
#     load_balancer_arn = aws_lb.this.arn
#     port              = 80
#     protocol          = "HTTP"

#     default_action {
#         type             = "fixed-response"
#         fixed_response {
#             content_type = "text/plain"
#             status_code = 301
#             message_body = "Moved Permanently"
#         }
#     }
# }

resource "aws_lb_listener" "app_listener" {
    load_balancer_arn = aws_lb.this.arn 
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this.arn
    }
}