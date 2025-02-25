variable "bastion_ec2_security_group_name" { type = string }
variable "bastion_ec2_security_group_description" { type = string }
variable "bastion_ec2_instance_type" { type = string }
variable "app_ec2_security_group_name" { type = string }
variable "app_ec2_security_group_description" { type = string }
variable "app_ec2_instance_type" { type = string }
variable "aws_ec2_key" { type = string }
variable "public_tag" { type = string }
variable "private_tag" { type = string }
variable "my_ip" { type = string }
## from vpc module
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
