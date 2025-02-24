module "flask-vpc" {
  source       = "./modules/vpc"
  vpc_name     = var.vpc_name
  vpc_cidr     = var.vpc_cidr
  num_azs      = var.num_azs
  public_tag   = var.public_tag
  private_tag  = var.private_tag
  s3_flow_logs = var.s3_flow_logs
}

module "flask-ec2" {
  source = "./modules/ec2"
}

module "flask-nat-gateway" {
  source      = "./modules/nat-gateway"
  public_tag  = var.public_tag
  private_tag = var.private_tag
}



# permanently delete