output "ec2_global_ips" {
    value = [for instance in aws_instance.bastion : instance.public_ip]
}

output "bastion_sg_id" {
    value = aws_security_group.bastion.id
}

output "app_sg_id" {
    value = aws_security_group.app.id
}

output "load_balancer_dns_name" {
    value = aws_lb.this.dns_name
}