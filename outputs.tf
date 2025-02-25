output "ec2_global_ips" {
  description = "IDs of EC2 instances"
  value       = module.flask-ec2.ec2_global_ips
}

# output "vpc_id" {
#   value = module.flask-vpc.vpc_id
# }

# output "public_subnet_ids" {
#     value = module.flask-vpc.public_subnet_ids
# }

# output "private_subnet_ids" {
#     value = module.flask-vpc.private_subnet_ids
# }
