provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami                         = "ami-0f58b397bc5c1f2e8"
  associate_public_ip_address = true
  availability_zone           = "ap-south-1c" # Corrected availability zone
  instance_type               = "t2.micro"
  key_name                    = "abdullah_key_new"
  subnet_id                   = aws_subnet.public_subnet.id

  tags = {
    "Name" = "terraform-ec2"
  }

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_internet_gateway" "my_igw" {
  tags = {
    "Name" = "terraform-gateway"
  }

  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "public_route_table" {
  tags = {
    "Name" = "terraform-route-table"
  }

  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.0.0/20"

  tags = {
    "Name" = "terraform-subnet"
  }

  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_vpc" "my_vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true

  tags = {
    "Name" = "terraform-vpc"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "terraform-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

