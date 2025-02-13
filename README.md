# flask
Use terraform to deploy a flask app. This code deploys a flask app to your AWS account and uses S3 with DynamoDB for remote backend.

# Follow along

 1. Create an S3 bucket in your amazon account to use for storing state files.
	 Ensure the bucket settings are as follows:
	 - Block all public access: True 
	 - Enable bucket versioning: True 
	 - Enable default encryption: True

	 Ensure the bucket policy includes the following:
	 - something  
	 - something  
	 - something

 2. Create a DynamoDB table for state locking.
	 Ensure the policy includes the following:
	 - something  
	 - something  
	 - something
	 
	Ensure the partition key is "LockID".
 3. Clone this repo locally
 4. Run `cd flask`
 5. Edit the providers.tf to include your bucket name and table name
 6. Run `terraform init`
 7. Run `terraform apply --auto-approve`

NOTE: This code is currently in sync with the Phase 1 diagram.

# Architecture Diagrams
The following diagrams show the gradual expansion of the application. In Phase 1, all of the basic networking to create a VPC is setup. There are public and private subnets across 2 availability zones. In Phase 2, there is a NAT gateway, security groups and VPC Flow logs.

## Phase 1 - VPC
![phase1 (1)](https://github.com/user-attachments/assets/4943765a-65ee-4597-ba07-09dfcf5cd4c1)
