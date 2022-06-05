Using Terraform Dynamic Blocks and Built-in Functions to Deploy to AWS

step-1: Clone Terraform Code and Switch to Proper Directory
Clone the terraform code required for this lab from the git repo using the command 

     git clone https://github.com/linuxacademy/content-hashicorp-certified-terraform-associate-foundations.git

Switch to the directory where the code is located: cd section7-HoL-TF-DynBlocks-Funcs.

List the files in the directory. The files in the directory should include 'main.tf', 'outputs.tf', 'variables.tf', and 'script.sh'.

step-2: Examine the code in the files

View the content of main.tf file:
 
   vim main.tf
   
      provider "aws" {
        region = "us-east-1"
      }

      data "aws_ssm_parameter" "ami_id" {
        name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
      }


     module "vpc" {
      source = "terraform-aws-modules/vpc/aws"

      name = "my-vpc"
      cidr = "10.0.0.0/16"

    azs            = ["us-east-1a"]
    public_subnets = ["10.0.1.0/24"]


    }


      resource "aws_security_group" "my-sg" {
       vpc_id = module.vpc.vpc_id
       name   = join("_", ["sg", module.vpc.vpc_id])
      dynamic "ingress" {
         for_each = var.rules
         content {
            from_port   = ingress.value["port"]
            to_port     = ingress.value["port"]
            protocol    = ingress.value["proto"]
            cidr_blocks = ingress.value["cidr_blocks"]
         }
     }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

   tags = {
    Name = "Terraform-Dynamic-SG"
  }
}

resource "aws_instance" "my-instance" {
  ami             = data.aws_ssm_parameter.ami_id.value
  subnet_id       = module.vpc.public_subnets[0]
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.my-sg.id]
  user_data       = fileexists("script.sh") ? file("script.sh") : null
}

