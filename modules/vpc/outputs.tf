output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
  #value       = aws_subnet.public[*].id
}

output "private_subnet_ids_ec2" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private_ec2 : subnet.id]
}

output "private_subnet_ids_rds" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private_rds : subnet.id]
}