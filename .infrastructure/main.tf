terraform {
  required_providers {
    archive = {
      source  = "opentofu/archive"
      version = "2.6.0"
    }
    aws = {
      source  = "opentofu/aws"
      version = "5.68.0"
    }
    null = {
      source  = "opentofu/null"
      version = "3.2.2"
    }
  }
  backend "s3" {
    bucket         = "architectf"
    key            = "endpoints"
    region         = "us-east-1"
    dynamodb_table = "architectf-timeline"
  }
  required_version = "1.8.3"
}

provider "aws" {
  region = "us-east-1"
}
