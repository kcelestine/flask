terraform {

  required_version = "1.10.1"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {                                 # Path within the S3 bucket to store the state file
    region         = "us-east-1"                 # The region where the S3 bucket is located
    encrypt        = true                        # Encrypt the state file using SSE-S3
    dynamodb_table = "terraform-lock"            # DynamoDB table for state locking
    acl            = "bucket-owner-full-control" # Set ACL for the state file
    bucket         = "khadijah-flask-app-state"
    key            = "dev/terraform.tfstate"
  }

}