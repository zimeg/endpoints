terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
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
