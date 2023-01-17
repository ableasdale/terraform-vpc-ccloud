provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "ubuntu_instance" {
    ami = "ami-01b8d743224353ffe" # Ubuntu 22.04 LTS (64bit x86)
    instance_type = "t2.micro"
    key_name = "*** NAME OF YOUR KEY PAIR GOES HERE ***"
    vpc_security_group_ids = [aws_security_group.main.id]

    tags = {
        Name = "ableasdale-ubuntu-instance"
        "Terraform" = "Yes"
    }
}

resource "aws_security_group" "main" {
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
}