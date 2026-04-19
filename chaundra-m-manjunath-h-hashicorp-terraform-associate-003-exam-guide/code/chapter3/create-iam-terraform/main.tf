terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "test_user" {
  name = "test-aws-user"
  path = "/test/"

  # Tags can be used for resource segregation and billing usage, among others
  tags = {
    "createdby" = "terraform"
  }
}

resource "aws_iam_access_key" "user_access_keys" {
  user = aws_iam_user.test_user.name
}
