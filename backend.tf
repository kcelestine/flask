terraform {
  backend "s3" {
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    acl            = "bucket-owner-full-control"
    bucket         = "khadijah-flask-app-state"
    key            = "dev/terraform.tfstate"
  }
}