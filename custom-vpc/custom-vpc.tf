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
  map_public_ip_on_launch = "${count.index == 3 ? true : false}" 

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
  map_public_ip_on_launch = "${count.index == 3 ? true : false}" 

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
  map_public_ip_on_launch = "${count.index == 3 ? true : false}" 

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

# Create some routes
resource "aws_route" "r" {
  route_table_id            = aws_route_table.prod-public-rtable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.vpc-igw.id
  depends_on                = [aws_route_table.prod-public-rtable]
}

resource "aws_route" "r6" {
  route_table_id              = aws_route_table.prod-public-rtable.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                = aws_internet_gateway.vpc-igw.id
  depends_on                = [aws_route_table.prod-public-rtable]
}

# Create BASTION host
resource "aws_instance" "bastion_host" {
    ami = "ami-084e8c05825742534" # Amazon Linux 2 AMI (64bit x86)
    instance_type = "t2.micro"
    key_name = "ableasdale-cflt"
    subnet_id = aws_subnet.privatesubnet-2a[3].id

    vpc_security_group_ids = [aws_security_group.bastion_host.id]

    tags = {
        Name = "ableasdale-tf-BASTION"
        "Terraform" = "Yes"
    }
}

resource "aws_security_group" "bastion_host" {
  vpc_id  = aws_vpc.prod-vpc.id
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = ["::/0"]
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
  tags = {
    Name = "ableasdale-tf-BASTION-SG"
    "Terraform" = "Yes"
  }
}