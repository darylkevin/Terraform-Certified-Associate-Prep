terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14"
    }
  }

  required_version = ">= 1.3.1"
}

provider "aws" {
  # profile = "default" REMOVED: to make use of localstack at .awslocal
  region  = "us-east-1"
}