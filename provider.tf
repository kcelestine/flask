provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "TERRAFORM"
    }
  }

  profile = "default"
}