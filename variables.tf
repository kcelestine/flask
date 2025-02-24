## VPC module ##
variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }
variable "num_azs" { type = string }
variable "public_tag" { type = string }
variable "private_tag" { type = string }
variable "s3_flow_logs" { type = string }

