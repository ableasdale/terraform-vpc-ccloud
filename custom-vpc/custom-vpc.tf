provider "aws" {
    region = "eu-west-2"
}

resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.16.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true

  tags = {
    Name = "ableasdale-tf-custom-vpc"
  }
}

# Private Subnet in eu-west-2a
resource "aws_subnet" "privatesubnet" {
  count             = 4
  cidr_block        = tolist(["10.16.0.0/20","10.16.16.0/20","10.16.32.0/20","10.16.48.0/20"])[count.index]
  vpc_id            = aws_vpc.prod-vpc.id

  ipv6_cidr_block = "${cidrsubnet(aws_vpc.prod-vpc.ipv6_cidr_block, 8, count.index + 1)}"
  assign_ipv6_address_on_creation = true
  # availability_zone = data.aws_availability_zones.availableAZ.names[count.index]

  # ipv6_cidr_block = "${cidrsubnet(aws_vpc.eu-central-1.ipv6_cidr_block, 8, 1)}"
  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2a"
    # Namespace = var.namespace
  }

  depends_on = [aws_vpc.prod-vpc]
}

# Private Subnet in eu-west-2b
resource "aws_subnet" "privatesubnet-2b" {
  count             = 4
  cidr_block        = tolist(["10.16.64.0/20","10.16.80.0/20","10.16.96.0/20","10.16.112.0/20"])[count.index]
  vpc_id            = aws_vpc.prod-vpc.id

  ipv6_cidr_block = "${cidrsubnet(aws_vpc.prod-vpc.ipv6_cidr_block, 8, count.index + 5)}"
  assign_ipv6_address_on_creation = true
  # availability_zone = data.aws_availability_zones.availableAZ.names[count.index]

  # ipv6_cidr_block = "${cidrsubnet(aws_vpc.eu-central-1.ipv6_cidr_block, 8, 1)}"
  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2b"
    # Namespace = var.namespace
  }

  depends_on = [aws_vpc.prod-vpc]
}

# Private Subnet in eu-west-2c
resource "aws_subnet" "privatesubnet-2c" {
  count             = 4
  cidr_block        = tolist(["10.16.128.0/20","10.16.144.0/20","10.16.160.0/20","10.16.176.0/20"])[count.index]
  vpc_id            = aws_vpc.prod-vpc.id

  ipv6_cidr_block = "${cidrsubnet(aws_vpc.prod-vpc.ipv6_cidr_block, 8, count.index + 10)}"
  assign_ipv6_address_on_creation = true
  # availability_zone = data.aws_availability_zones.availableAZ.names[count.index]

  # ipv6_cidr_block = "${cidrsubnet(aws_vpc.eu-central-1.ipv6_cidr_block, 8, 1)}"
  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2b"
    # Namespace = var.namespace
  }

  depends_on = [aws_vpc.prod-vpc]
}

resource "aws_internet_gateway" "simple_igw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "ableasdale-tf-igw"
    }
}