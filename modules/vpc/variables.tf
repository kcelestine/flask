variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }
variable "num_azs" { type = string }
variable "public_tag" { type = string }
variable "private_tag" { type = string }

variable "subnet_az_1a" {
  type    = string
  default = "us-east-1a"
}

variable "subnet_az_1b" {
  type    = string
  default = "us-east-1b"
}

variable "s3_flow_logs" { type = string }
