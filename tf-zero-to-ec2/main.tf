provider "aws" {
  region = "eu-central-1"
}

module "vm_in_vpc" {
  source = "./vm-in-vpc-module"
  ami_id = "ami-0626c3710f2082e41" #rocky linux9.1 
    instance_type = "t2.micro"
    key_name = "ssh-22-vs-random-key"
    volume_size = 12
}



