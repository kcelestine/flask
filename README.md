
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
	 Ensure the bucket settings are as follows:
	 - Block all public access: True 
	 - Enable bucket versioning: True 
	 - Enable default encryption: True

	Ensure the bucket policy includes the following:
	 - something  
	 - something  
	 - something

 3. Create a DynamoDB table for state locking.
	 Ensure the policy includes the following:
	 - something  
	 - something  
	 - something
	 
	Ensure the partition key is "LockID".
 4. Clone this repo locally
 5. Run `cd flask`
 6. Edit the backend.tf to include your bucket name and table name
 7. Run `terraform init`
 8. Run `terraform apply --auto-approve`

NOTE: This code is currently in sync with the Phase 1 diagram.

# Architecture Diagrams
The following diagrams show the gradual expansion of the application. In Phase 1, all of the basic networking to create a VPC is setup. There are public and private subnets across 2 availability zones. In Phase 2, there is a NAT gateway, security groups and VPC Flow logs.

## Phase 1 - VPC
![phase1 (1)](https://github.com/user-attachments/assets/4943765a-65ee-4597-ba07-09dfcf5cd4c1)

## Phase 2 - Networking
![phase2-flask drawio](https://github.com/user-attachments/assets/ba59f6a1-e373-49a5-b56c-8a2a1f355107)

## Phase 3 - Compute
![phase3-flask drawio](https://github.com/user-attachments/assets/871ae544-1e67-4845-a271-fae259cc6fb8)

## Phase 4 - RDS
![phase4 (4)]()
