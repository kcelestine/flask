module "flask-vpc" {
  source       = "./modules/vpc"
  vpc_name     = var.vpc_name
  vpc_cidr     = var.vpc_cidr
  num_azs      = var.num_azs
  public_tag   = var.public_tag
  private_tag  = var.private_tag
  s3_flow_logs = var.s3_flow_logs
  #remove later
  ec2_instance_type = var.ec2_instance_type
  ec2_security_group_name = var.ec2_security_group_name
  ec2_security_group_description = var.ec2_security_group_description
}

module "flask-ec2" {
  source = "./modules/ec2"
  ec2_security_group_name = var.ec2_security_group_name
  ec2_security_group_description = var.ec2_security_group_description
  ec2_instance_type = var.ec2_instance_type
  aws_ec2_key = "wp"
  public_tag  = var.public_tag
  private_tag = var.private_tag
  vpc_id       = module.flask-vpc.vpc_id
}

module "flask-vpc-flow-logs" {
  source = "./modules/vpc-flow-logs"
  s3_flow_logs = var.s3_flow_logs
}
# permanently delete