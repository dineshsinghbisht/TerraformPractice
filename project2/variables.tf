
variable "aws_region" {
  description = "Enter the region where VPC and other resources will be created"
  default     = "eu-west-1"
}
variable "vpc_cidr_block" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
variable "owner_name" {
  description = "Name of the Owner"
  default     = "Dinesh"
}
variable "az_count" {
  description = "Number of AZs to be used for High Availaibility"
  default     = "2"
}

