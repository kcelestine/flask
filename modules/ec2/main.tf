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

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
    security_group_id = aws_security_group.bastion.id

    #cidr_ipv4   = "0.0.0.0/0"
    cidr_ipv4   = var.my_ip
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
    security_group_id = aws_security_group.bastion.id

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 0
    to_port     = 0
}

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

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion" {
    security_group_id = aws_security_group.app.id

    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    #cidr_ipv4 = [""]  # No direct SSH access from the public internet -- by leaving it out, is it implied no public access?
    referenced_security_group_id = aws_security_group.bastion.id  # Allow traffic from Bastion Host
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_to_nat" {
    security_group_id = aws_security_group.app.id

    from_port   = 0
    to_port     = 0
    ip_protocol =  "tcp" # Allow all outbound traffic
    cidr_ipv4 = "0.0.0.0/0"  # NAT Gateway handles outbound internet access aaccording to route table
}

resource "aws_instance" "app" {
    #for_each = toset(var.public_subnet_ids)
    #subnet_id      = each.value
    count          = length(var.private_subnet_ids)
    subnet_id = var.private_subnet_ids[count.index]
    ami             = data.aws_ami.ubuntu.id
    instance_type   = var.app_ec2_instance_type
    vpc_security_group_ids = [aws_security_group.app.id]
    key_name = var.aws_ec2_key # ok to have the same key as public instance?
    user_data = file("install-flask-app.sh")
    tags = {
        Name = var.private_tag
    }
}