provider "aws" {
  region = "eu-central-1"
}

module "vm_in_vpc" {
  source = "./vm-in-vpc-module"
  ami_id = "ami-0626c3710f2082e41" #rocky linux9.1 
  instance_type = "t2.micro"
  instance_name = "z2ec2-demo"
  key_name = "z2ec2-key" #must already exist in AWS
  volume_size = 12 #in GB
  open_ports = ["22", "80", "443"]
  user_data =   <<-EOF
                #!/bin/bash
                sudo mkdir -p /opt/z2ec2/demo
                sudo dnf update -y
                EOF
}
