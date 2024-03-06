# resource "aws_security_group" "ssh-22-vs-random-22" {
#   name        = "secgr-ssh-22-vs-random-22"
#   description = "Relevant ports for ssh-22-vs-random-22"
#   vpc_id      = aws_vpc.ssh_22_vs_random.id


#   # ingress {
#   #   from_port   = 0
#   #   to_port     = 0  # Allow all ports
#   #   protocol    = "-1"
#   #   cidr_blocks = ["0.0.0.0/0"]
#   # }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0 # Allow all ports
#     protocol    = "-1"   # Allow all protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ssh-22-vs-random-security-group-22"
#   }
# }

# resource "aws_security_group" "ssh-22-vs-random-48931" {
#   name        = "secgr-ssh-22-vs-random-48931"
#   description = "Relevant ports for ssh-22-vs-random-48931"
#   vpc_id      = aws_vpc.ssh_22_vs_random.id


#   # ingress {
#   #   from_port   = 0
#   #   to_port     = 0  # Allow all ports
#   #   protocol    = "-1"
#   #   cidr_blocks = ["0.0.0.0/0"]
#   # }

#   ingress {
#     from_port   = 48931
#     to_port     = 48931
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0 # Allow all ports
#     protocol    = "-1"   # Allow all protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ssh-22-vs-random-security-group-48931"
#   }
# }

# resource "aws_instance" "vm-ssh-22" {
#   ami           = "ami-0626c3710f2082e41" #rocky linux9.1 
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.ssh_22_vs_random.id
#   key_name      = "ssh-22-vs-random-key"
#   security_groups = [
#     aws_security_group.ssh-22-vs-random-22.id
#   ]
  
#   root_block_device {
#     volume_size = 12 
#     delete_on_termination = true  
#   }

#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo dnf update -y
#                 EOF

#   tags = {
#     Name = "vm-ssh-22"
#     Region = "eu-central-1"
#     CreatedBy = "Terraform"
#   }
# }

######################################

provider "aws" {
    region = "eu-central-1"
}


variable "ami_id" {
  description = "AMI ID"
}

variable "instance_type" {
  description = "Instance Type"
}

variable "key_name" {
  description = "Key Pair Name"
}

variable "volume_size" {
  description = "Volume Size in GB"
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

resource "aws_instance" "z2ec2_instance" {

  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.z2ec2_subnet.id
  key_name      = var.key_name
#   security_groups = [
#     aws_security_group.ssh-22-vs-random-22.id
#   ]
  
  root_block_device {
    volume_size = var.volume_size
    delete_on_termination = true  
  }

#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo dnf update -y
#                 EOF

#   tags = {
#     Name = "vm-ssh-22"
#     Region = "eu-central-1"
#     CreatedBy = "Terraform"
#   }
}
