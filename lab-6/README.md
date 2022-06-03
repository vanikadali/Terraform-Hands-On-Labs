Building and Testing a Basic Terraform Module

Create the Directory Structure for the Terraform Project

step-1: Check the Terraform status using the version command:

    terraform version

step-2: Create a new directory called terraform_project to house your Terraform code:

    mkdir terraform_project

step-3: Switch to this main project directory:

    cd terraform_project
    
step-4: Create a custom directory called modules and a directory inside it called vpc:

      mkdir -p modules/vpc
      
step-5: Switch to the vpc directory using the absolute path:

     cd /home/cloud_user/terraform_project/modules/vpc/
     
     
Write Your Terraform VPC Module Code


step-1: create a new file called main.tf:
 
   vim main.tf
   
step-2:  insert the following code in main.tf file

       provider "aws"  {
   
          region = var.region
      
       }

       resource "aws_vpc" "this" {
   
          cidr_block = "10.0.0.0/16"
      
       }

       resource "aws_subnet" "this" {
   
           vpc_id     = aws_vpc.this.id
      
           cidr_block = "10.0.1.0/24"
       }

       data "aws_ssm_parameter" "this" {
   
            name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
       
       }
       
       
step-3: Create a new file called variables.tf:

   vim variables.tf
   
 step-4: in that file inserts the following code
 
      variable "region" {
         type    = string
         default = "us-east-1"
      }
      
step-5: create another file called outputs.tf

      vim outputs.tf
   
   
step-6: in the outputs.tf file paste the following code

    output "subnet_id" {
        value = aws_subnet.this.id
    }

    output "ami_id" {
       value = data.aws_ssm_parameter.this.value
    }
    
 Write Your Main Terraform Project Code
  
  step-1: Switch to the main project directory:
  
     cd ~/terraform_project
     
step-2: create a new file called main.tf:

  vim main.tf
  
step-3: in the file , paste the following code

    variable "main_region" {
       type    = string
       default = "us-east-1"
    }

    provider "aws" {
        region = var.main_region
    }

    module "vpc" {
      source = "./modules/vpc"
      region = var.main_region
    }

    resource "aws_instance" "my-instance" {
       ami           = module.vpc.ami_id
       subnet_id     = module.vpc.subnet_id
       instance_type = "t2.micro"
    }
    
step-4: create a new file called outputs.tf:

   vim outputs.tf
   
step-5: insert the following code

         output "PrivateIP" {
           description = "Private IP of EC2 instance"
           value       = aws_instance.my-instance.private_ip
         }
  
Deploy your code nd test out your module

step-1: Format the code in all of your files in preparation for deployment:

    terraform fmt -recursive

step-2: Initialize the Terraform configuration to fetch any required providers and get the code being referenced in the module block:

     terraform init

step-3 : Validate the code to look for any errors in syntax, parameters, or attributes within Terraform resources that may prevent it from deploying correctly:

     terraform validate
 
step-4: Review the actions that will be performed when you deploy the Terraform code

     terraform plan
 
step-5: Deploy the code :
   
     terraform apply --auto-approve
   
step-6 :

Once the code has executed successfully, note in the output that 3 resources have been created and the private IP address of the EC2 instance is returned as was configured in the outputs.tf file in your main project code.

step-7: View all of the resources that Terraform has created and is now tracking in the state file:

       terraform state list
   
step-8: Tear down the infrastructure you just created before moving on:

       terraform destroy
