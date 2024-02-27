provider "aws" {
    region = "eu-central-1"
    #AWS_ACCESS_KEY and AWS_SECRET_KEY are set as environment variables
}

resource "aws_vpc" "ssh_22_vs_random" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "vpc-ssh-22-vs-random"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_subnet" "ssh_22_vs_random" {
  cidr_block = "10.10.0.0/24"
  vpc_id = aws_vpc.ssh_22_vs_random.id
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-ssh-22-vs-random"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
    Public = "true"
    AvailabilityZone = "eu-central-1a"
  }
}

resource "aws_internet_gateway" "ssh_22_vs_random" {
  vpc_id=aws_vpc.ssh_22_vs_random.id

  tags = {
    Name = "igw-ssh-22-vs-random"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_route_table" "ssh_22_vs_random" {
  vpc_id =aws_vpc.ssh_22_vs_random.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ssh_22_vs_random.id
  }

  tags = {
    Name = "rt-ssh-22-vs-random"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.ssh_22_vs_random.id
  route_table_id = aws_route_table.ssh_22_vs_random.id
}

resource "aws_security_group" "ssh-22-vs-random-22" {
  name        = "secgr-ssh-22-vs-random-22"
  description = "Relevant ports for ssh-22-vs-random-22"
  vpc_id      = aws_vpc.ssh_22_vs_random.id


  # ingress {
  #   from_port   = 0
  #   to_port     = 0  # Allow all ports
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0 # Allow all ports
    protocol    = "-1"   # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-22-vs-random-security-group-22"
  }
}

resource "aws_security_group" "ssh-22-vs-random-48931" {
  name        = "secgr-ssh-22-vs-random-48931"
  description = "Relevant ports for ssh-22-vs-random-48931"
  vpc_id      = aws_vpc.ssh_22_vs_random.id


  # ingress {
  #   from_port   = 0
  #   to_port     = 0  # Allow all ports
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 48931
    to_port     = 48931
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0 # Allow all ports
    protocol    = "-1"   # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-22-vs-random-security-group-48931"
  }
}

resource "aws_instance" "vm-ssh-22" {
  ami           = "ami-0626c3710f2082e41" #rocky linux9.1 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ssh_22_vs_random.id
  key_name      = "ssh-22-vs-random-key"
  security_groups = [
    aws_security_group.ssh-22-vs-random-22.id
  ]
  
  root_block_device {
    volume_size = 12 
    delete_on_termination = true  
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo dnf update -y
                EOF

  tags = {
    Name = "vm-ssh-22"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}

resource "aws_instance" "vm-ssh-48931" {
  ami           = "ami-0626c3710f2082e41" #rocky linux9.1 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ssh_22_vs_random.id
  key_name      = "ssh-22-vs-random-key"
  security_groups = [
    aws_security_group.ssh-22-vs-random-48931.id
  ]
  
  root_block_device {
    volume_size = 12 
    delete_on_termination = true  
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo dnf update -y
                sudo dnf install -y firewalld
                sudo systemctl start firewalld
                sudo systemctl enable firewalld
                sudo firewall-cmd --zone=public --add-port=48931/tcp --permanent
                sudo firewall-cmd --reload
                sudo sed -i 's/#Port 22/Port 48931/' /etc/ssh/sshd_config
                sudo systemctl restart sshd
                EOF

  tags = {
    Name = "vm-ssh-48931"
    Region = "eu-central-1"
    CreatedBy = "Terraform"
  }
}



