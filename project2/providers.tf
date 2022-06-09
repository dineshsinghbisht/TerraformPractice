terraform {
#   required_version = ">=1.2.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    #   version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  # access_key =
  # secret_key =
}