resource "aws_security_group" "rds" {
    name        = var.rds_security_group_name
    description = var.rds_security_group_description
    vpc_id     = var.vpc_id
}

  resource "aws_vpc_security_group_ingress_rule" "rds_mysql" {
      security_group_id = aws_security_group.rds.id

      from_port   = 3306
      to_port     = 3306
      ip_protocol = "tcp"
      #referenced_security_group_id = var.app_sg_id  # Allow traffic from private instance
	  cidr_ipv4   = "0.0.0.0/0"
  }

resource "aws_vpc_security_group_egress_rule" "rds_outbund" {
    security_group_id = aws_security_group.rds.id
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_db_instance" "this" {
    identifier             = "flask-db"
    engine                 = "mysql"
    engine_version         = "8.0"
    instance_class         = var.rds_instance_type
    allocated_storage      = 20
    storage_type           = "gp2"
    username               = var.db_admin
    manage_master_user_password = true
    db_name                = var.rds_db_name
    skip_final_snapshot    = true
    publicly_accessible    = false
    vpc_security_group_ids = [aws_security_group.rds.id]
    db_subnet_group_name   = aws_db_subnet_group.data.name
	multi_az				= true
    storage_encrypted      = true
	delete_automated_backups = true # only use for terraform testing, not production
	backup_retention_period = 7
  	backup_window           = "03:00-04:00"
  	maintenance_window      = "sun:05:00-sun:06:00"
	# in production, do not delete on destroy
	# lifecycle {
    # 	prevent_destroy = true
	# }
    tags = {
      Name = var.private_tag
    }
}

resource "aws_db_subnet_group" "data" {
    name       = var.private_subnet_group_data
    subnet_ids = [for subnet in var.private_subnet_ids_rds : subnet]

    tags = {
        Name = var.private_tag
    }
}