provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "my_instance" {
  ami                         = "ami-0f58b397bc5c1f2e8"
  associate_public_ip_address = true
  availability_zone           = "ap-south-1b"
  instance_type               = "t2.micro"
  key_name                    = "abdullah_key_new"
  subnet_id                   = "subnet-021075ff329a6aa2f"

  tags = {
    "Name" = "terraform-ec2"
  }

  vpc_security_group_ids = ["sg-092a8702ace82fd27"]
}

resource "aws_internet_gateway" "my_igw" {
  tags = {
    "Name" = "terraform-gateway"
  }

  vpc_id = "vpc-0935a5ad02d577264"
}

resource "aws_route_table" "public_route_table" {
  tags = {
    "Name" = "terraform-route-table"
  }

  vpc_id = "vpc-0935a5ad02d577264"
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.0.0/20"

  tags = {
    "Name" = "terraform-subnet"
  }

  vpc_id = "vpc-0935a5ad02d577264"
}

resource "aws_vpc" "my_vpc" {
  cidr_block        = "10.0.0.0/16"
  enable_dns_support = true

  tags = {
    "Name" = "terraform-vpc"
  }
}
