output "ec2_global_ips" {
    value = [for instance in aws_instance.bastion : instance.public_ip]
}