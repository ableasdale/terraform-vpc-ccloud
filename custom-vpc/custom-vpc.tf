provider "aws" {
    region = "eu-west-2"
}

resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.16.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "ableasdale-tf-custom-vpc"
  }
}