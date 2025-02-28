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
  source                                 = "./modules/ec2"
  bastion_ec2_security_group_name        = var.bastion_ec2_security_group_name
  bastion_ec2_security_group_description = var.bastion_ec2_security_group_description
  bastion_ec2_instance_type              = var.bastion_ec2_instance_type
  app_ec2_security_group_name            = var.app_ec2_security_group_name
  app_ec2_security_group_description     = var.app_ec2_security_group_description
  app_ec2_instance_type                  = var.app_ec2_instance_type
  aws_ec2_key                            = "wp"
  public_tag                             = var.public_tag
  private_tag                            = var.private_tag
  my_ip                                  = var.my_ip
  #from vpc module
  vpc_id             = module.flask-vpc.vpc_id
  public_subnet_ids  = module.flask-vpc.public_subnet_ids
  private_subnet_ids_ec2 = module.flask-vpc.private_subnet_ids_ec2
}

module "flask-vpc-flow-logs" {
  source       = "./modules/vpc-flow-logs"
  s3_flow_logs = var.s3_flow_logs
  vpc_id       = module.flask-vpc.vpc_id
}
# permanently delete

module "flask-rds" {
    source                                 = "./modules/rds"
    db_pass = var.db_pass
    rds_db_name = var.rds_db_name
    rds_instance_type = var.rds_instance_type
    rds_security_group_name = var.rds_security_group_name
    rds_security_group_description = var.rds_security_group_description
    private_tag                            = var.private_tag
    private_subnet_group_data = var.private_subnet_group_data
    #from vpc module
    vpc_id             = module.flask-vpc.vpc_id
    private_subnet_ids_rds = module.flask-vpc.private_subnet_ids_rds
}