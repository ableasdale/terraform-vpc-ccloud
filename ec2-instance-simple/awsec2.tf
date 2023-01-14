provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "ubuntu_instance" {
    ami = "ami-01b8d743224353ffe" # Ubuntu 22.04 LTS (64bit x86)
    instance_type = "t2.micro"

    tags = {
        Name = "ableasdale-ubuntu-instance"
        "Terraform" = "Yes"
    }
}