

# flask
Use terraform to deploy a flask app. This code deploys a flask app to your AWS account and uses S3 with DynamoDB for remote backend.

# Follow along

 1. Create a user to be used with your terraform commands with the following policy applied:

```{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"iam:*",
				"rds:*",
				"s3:*",
				"route53:*",
				"ec2:*",
				"dynamodb:*"
			],
			"Resource": "*"
		}
	]
}
```
    

 2. Create an S3 bucket in your amazon account to use for storing state files.
	 Add the following bucket settings]:
	 - Block all public access: True 
	 - Enable bucket versioning: True 
	 - Enable default encryption: True

 3. Create a DynamoDB table for state locking.
	Ensure the partition key is "LockID".
	
 4. Create ec2 key file (referenced in terraform.tfvars file to create instances)
 5. Create ACM certificate with a domain name you own
 6. Clone this repo locally
 7. Run `cd flask`
 8. Edit the backend.tf to include your bucket name and table name
 9. Create terraform.tfvars file
```
# global vars
public_tag =  "dev-flask-public"
private_tag =  "dev-flask-private"

# vpc vars
vpc_name =  "dev-flask-vpc"
s3_flow_logs =  #name to give s3 bucket for vpc-flow-logs
vpc_cidr =  "10.0.0.0/16"
num_azs =  2

# ec2 vars
app_ec2_instance_type =  "t2.micro"
app_ec2_security_group_name =  "dev-flask-sg-app-private"
app_ec2_security_group_description =  "Security group for flask application server EC2 instance"
bastion_ec2_instance_type =  "t2.micro"
bastion_ec2_security_group_name =  "dev-flask-sg-bastion-public"
bastion_ec2_security_group_description =  "Security group for flask bastion host EC2 instance"
my_ip =  "0.0.0.0/32" # your local ip
aws_ec2_key =  "" # name of key file created in step 4 - do not include .pem
alb_security_group_name =  "dev-flask-alb"
alb_security_group_description =  "ALB for flask app private instances"
alb_tg_name =  "dev-flask-tg"
domain_name =  "*.yourdomain.com" #domain name used when creating certificate in step 5.

# rds vars
db_admin =  ""  # use aws secrets manager
rds_db_name =  ""
rds_instance_type =  "db.t3.micro"
rds_security_group_description =  "Security group for flask RDS instance"
rds_security_group_name =  "dev-flask-sg-rds"
private_subnet_group_data =  "dev-flask-subnet-group"
```
 10. Run `terraform init`
 11. Run `terraform apply --auto-approve`

# Architecture Diagrams
![phase7 drawio](https://github.com/user-attachments/assets/faa60bd4-a5b7-4880-bc20-1ba27d3feae7)

