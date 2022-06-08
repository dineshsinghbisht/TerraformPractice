terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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
  instance_type = "t2.micro"

  tags = {
    Name = "For-Demo"
    Owner = "dinesh"
  }
}