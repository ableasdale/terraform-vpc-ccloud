provider "aws" {
    region = "eu-west-2"
}

resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.16.0.0/16"

  tags = {
    Name = "ableasdale-tf-vpc"
  }
}