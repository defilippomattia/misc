provider "aws" {
    region = "eu-central-1"
}

variable "ami_id" {description = "AMI ID"}
variable "instance_type" {description = "Instance Type"}
variable "instance_name" {description = "Instance Name"}
variable "user_data" {description = "User Data"}
variable "key_name" {description = "Key Pair Name"}
variable "volume_size" {description = "Volume Size in GB"}
variable "open_ports" {
  description = "List of open ports"
  type        = list(number)
}

resource "aws_vpc" "z2ec2_vpc" {
  cidr_block = "10.10.10.0/24"

  tags = {
    Name      = "z2ec2-vpc"
    Region    = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_subnet" "z2ec2_subnet" {
  cidr_block = "10.10.10.0/24"
  vpc_id = aws_vpc.z2ec2_vpc.id
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "z2ec2-subnet"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
    Public = "true"
    AvailabilityZone = "eu-central-1a"
  }
}

resource "aws_internet_gateway" "z2ec2_igw" {
  vpc_id=aws_vpc.z2ec2_vpc.id

  tags = {
    Name = "z2ec2-igw"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_route_table" "z2ec2_rt" {
  vpc_id=aws_vpc.z2ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.z2ec2_igw.id
  }

  tags = {
    Name = "z2ec2-rt"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_route_table_association" "z2ec2_subnet_association" {
  subnet_id      = aws_subnet.z2ec2_subnet.id
  route_table_id = aws_route_table.z2ec2_rt.id
}

resource "aws_security_group" "z2ec2_sg" {
  name        = "z2ec2-sg"
  description = "Relevant ports for z2ec2"
  vpc_id      = aws_vpc.z2ec2_vpc.id

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "z2ec2-sg"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_instance" "z2ec2_instance" {

  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.z2ec2_subnet.id
  key_name      = var.key_name
  security_groups = [
    aws_security_group.z2ec2_sg.id
  ]
  
  root_block_device {
    volume_size = var.volume_size
    delete_on_termination = true  
  }

  user_data = var.user_data

  tags = {
    Name = var.instance_name
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}
