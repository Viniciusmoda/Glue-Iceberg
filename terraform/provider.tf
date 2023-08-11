terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket         	   = "my-bucket"
    key              	   = "glue-job-state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
  }
}