terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
  }
  backend "s3" {
    bucket         = "architectf"
    key            = "endpoints"
    region         = "us-east-1"
    dynamodb_table = "architectf-timeline"
  }
  required_version = "~> 1.1"
}

provider "aws" {
  region = "us-east-1"
}
