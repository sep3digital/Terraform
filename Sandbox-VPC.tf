terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "Users/admin/.aws/credentials"
  profile = "terraform"
}

# Create a VPC
resource "aws_vpc" "staging1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "staging1"
    }
  }
}