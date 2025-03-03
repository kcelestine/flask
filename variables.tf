## all modules ##
variable "public_tag" { type = string }
variable "private_tag" { type = string }

## VPC module ##
variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }
variable "num_azs" { type = string }
variable "s3_flow_logs" { type = string }

# ## EC2 module ##
# variable "ec2_security_group_name" { type = string }
# variable "ec2_security_group_description" { type = string }
# variable "ec2_instance_type" { type = string }
#variable "aws_ec2_key" { type = string }
#variable "vpc_id" { type = string }
variable "bastion_ec2_security_group_name" { type = string }
variable "bastion_ec2_security_group_description" { type = string }
variable "bastion_ec2_instance_type" { type = string }
variable "app_ec2_security_group_name" { type = string }
variable "app_ec2_security_group_description" { type = string }
variable "app_ec2_instance_type" { type = string }
variable "aws_ec2_key" { type = string }
variable "alb_security_group_name" { type = string }
variable "alb_security_group_description" { type = string }

# ## RDS module ##
variable "rds_security_group_name" { type = string }
variable "rds_security_group_description" { type = string }
variable "rds_instance_type" { type = string }
variable "db_pass" { type = string }
variable "rds_db_name" { type = string }
variable "private_subnet_group_data" { type = string }
variable "my_ip" { type = string }
variable "bastion_sg_id" { type = string }
