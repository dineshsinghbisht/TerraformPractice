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

resource "aws_instance" "web" {
  ami           = "ami-0c1bc246476a5572b"
  instance_type = var.instanceType

  tags = {
    Name  = "For-Demo"
    Owner = "dinesh"
  }
}