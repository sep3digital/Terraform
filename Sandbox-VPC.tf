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

variable "subnet_prefix" {
    description = "cidr block for the subnet"
}

variable "subnet_id" {
    description = "id of the subnet"
}

# Create a VPC
resource "aws_vpc" "vpc-staging1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-staging1"
  }
  
}

# Create Subnets
resource "aws_subnet" "pub-subnet-1" {
  vpc_id = aws_vpc.vpc-staging1.id
  cidr_block = var.subnet_prefix[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub-subnet-1"
  }
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id = aws_vpc.vpc-staging1.id
  cidr_block = var.subnet_prefix[1]
  availability_zone = "us-east-1c"

  tags = {
    Name = "pub-subnet-2"
  }
}

# Create a Route Table
resource "aws_route_table" "rt-staging1" {
  vpc_id = aws_vpc.vpc-staging1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-staging1.id
  }

  tags = {
    Name = "rt-staging1"
  }
}

# Associate a subnet to a route table
resource "aws_route_table_association" "pub-subnet-1" {
  subnet_id      = var.subnet_id[0]
  route_table_id = aws_route_table.rt-staging1.id
}

# Create an IGW
resource "aws_internet_gateway" "igw-staging1" {
  vpc_id = aws_vpc.vpc-staging1.id

  tags = {
    Name = "igw-staging1"
  }
}