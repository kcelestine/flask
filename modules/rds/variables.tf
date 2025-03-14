variable "rds_security_group_name" { type = string }
variable "rds_security_group_description" { type = string }
variable "rds_instance_type" { type = string }
variable "private_tag" { type = string }
variable "db_admin" { type = string }
variable "rds_db_name" { type = string }

## from vpc module
variable "vpc_id" { type = string }
variable "private_subnet_ids_rds" { type = list(string) }
variable "private_subnet_group_data" { type = string}

# from ec2 module
variable "app_sg_id" { type = string }