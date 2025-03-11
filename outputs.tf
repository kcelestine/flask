output "ec2_global_ips" {
  description = "IDs of EC2 instances"
  value       = module.flask-ec2.ec2_global_ips
}

output "bastion_sg_id" {
  value = module.flask-ec2.bastion_sg_id
}

output "app_sg_id" {
  value = module.flask-ec2.app_sg_id
}
output "load_balancer_dns_name" {
  value = module.flask-ec2.load_balancer_dns_name
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
