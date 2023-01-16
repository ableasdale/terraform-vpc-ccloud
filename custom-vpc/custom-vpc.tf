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

# Create Private Subnets in eu-west-2a
resource "aws_subnet" "privatesubnet-2a" {
  count             = 4
  cidr_block        = tolist(["10.16.0.0/20","10.16.16.0/20","10.16.32.0/20","10.16.48.0/20"])[count.index]
  vpc_id            = aws_vpc.prod-vpc.id

  ipv6_cidr_block = "${cidrsubnet(aws_vpc.prod-vpc.ipv6_cidr_block, 8, count.index + 1)}"
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2a"
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

  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2b"
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

  tags = {
    Name = "ableasdale-tf-privatesubnet-${count.index + 1}"
    AZ   = "eu-west-2c"
  }

  depends_on = [aws_vpc.prod-vpc]
}

# Create AWS Internet GateWay (IGW)
resource "aws_internet_gateway" "vpc-igw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "ableasdale-tf-igw"
    }
}

# Create Route Table for public subnets
resource "aws_route_table" "prod-public-rtable" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "ableasdale-tf-public-rtable"
  }
}

# Associate RT with ableasdale-tf-privatesubnet-4 in eu-west-2a
resource "aws_route_table_association" "public-web-2a" {
  subnet_id = aws_subnet.privatesubnet-2a[3].id 
  route_table_id = aws_route_table.prod-public-rtable.id
}

# Associate RT with ableasdale-tf-privatesubnet-4 in eu-west-2b
resource "aws_route_table_association" "public-web-2b" {
  subnet_id = aws_subnet.privatesubnet-2b[3].id
  route_table_id = aws_route_table.prod-public-rtable.id
}

# Associate RT with ableasdale-tf-privatesubnet-4 in eu-west-2c
resource "aws_route_table_association" "public-web-2c" {
  subnet_id = aws_subnet.privatesubnet-2c[3].id
  route_table_id = aws_route_table.prod-public-rtable.id
}