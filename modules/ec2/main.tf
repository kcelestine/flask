# Data Source for Latest Ubuntu 24 AMI
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "ec2" {
  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description
  vpc_id     = var.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     #security_groups = [aws_security_group.alb.id]
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
}

resource "aws_vpc_security_group_ingress_rule" "ec2" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "ec2" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 0
  to_port     = 0
}

# EC2 Instance Configuration
resource "aws_instance" "this" {
    #for_each = toset(var.public_subnet_ids)
    #subnet_id      = each.value
    count          = length(var.public_subnet_ids)
    subnet_id = var.public_subnet_ids[count.index]
    ami             = data.aws_ami.ubuntu.id
    instance_type   = var.ec2_instance_type
    vpc_security_group_ids = [aws_security_group.ec2.id]

    tags = {
        Name = var.public_tag
    }
}
