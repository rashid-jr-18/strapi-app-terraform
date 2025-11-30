# VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "strapi-vpc" }
}

# Subnet
resource "aws_subnet" "strapi_subnet" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "strapi-subnet" }
}

# Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
  tags = { Name = "strapi-igw" }
}

# Route Table
resource "aws_route_table" "strapi_rt" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
  tags = { Name = "strapi-rt" }
}

# Route Table Association
resource "aws_route_table_association" "strapi_rta" {
  subnet_id      = aws_subnet.strapi_subnet.id
  route_table_id = aws_route_table.strapi_rt.id
}

# Security Group
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.strapi_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 1337
  to_port     = 1337
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance with Strapi setup
resource "aws_instance" "strapi_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.strapi_subnet.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name      = var.key_name

  tags = { Name = "Strapi-EC2" }

    user_data = <<-EOF
              #!/bin/bash
              set -xe
              exec > /var/log/user-data.log 2>&1

              # Update & install essentials
              apt-get update -y
              apt-get install -y curl gnupg build-essential

              curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt install -y nodejs

              # Install yarn
              npm install -g yarn

              # Prepare home directory
              mkdir -p /home/ubuntu
              chown ubuntu:ubuntu /home/ubuntu
              cd /home/ubuntu

              # Create Strapi project (non-interactive)
              # Using --no-run so it doesn't block cloud-init
              sudo -u ubuntu npx create-strapi-app@latest strapi-app --quickstart --no-run
              EOF

}