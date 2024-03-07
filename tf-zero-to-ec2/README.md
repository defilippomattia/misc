# tf-zero-to-ec2

Terraform module to create an EC2 instance on AWS. Make changes to `./tf-zero-to-ec2/main.tf` to customize the instance.

`cd tf-zero-to-ec2`  
`terraform init`  
`terraform plan`  
`terraform apply -auto-approve`  
`terraform destroy -auto-approve`

# Limitations

- only eu-central-1 region
- only tcp ports
- manual ssh key creation
