Troubleshooting a Terraform Deployment

Correct the Variable Interpolation Error

step-1: view the contents of your current directory:

    ls
You should see the lab-terraform-troubleshooting directory, the lab-terraform-troubleshooting.zip package, and the resource_ids.txt file.

step-2: Change into the lab-terraform-troubleshooting directory
   
       cd lab-terraform-troubleshooting/
    
step-3:Edit the ami in the main.tf file
 
        terraform {
           
           required_providers {
               
               aws = {
                 
                 source  = "hashicorp/aws"
                 
                 version = ">= 3.24.1"
               }
          }
          
          required_version = "~> 1.0"
         
         }

         provider "aws" {
             
             region = var.region
         }

         resource "aws_instance" "web_app" {
            
            ami                    = <DUMMY VALUE>
            
            subnet_id              = <DUMMY VALUE>
            
            instance_type          = "t3.micro"
            
            user_data              = <<-EOF
              
                   #!/bin/bash
                   
                   echo "Hello, World" > index.html
                   
                   nohup busybox httpd -f -p 8080 &
                  
                  EOF
          tags = {
             
             Name = $var.name-learn
           }
         }
         
 step-4: open the resource_ids.txt file:
 
      vim ../resource_ids.txt
 
       ami: ami-06eecef118bbf9259
       subnet_id: subnet-09f45349ae8d5cae7
       
  In the resource block, edit the mainid and subnetid line by replacing <DUMMY VALUE> with your copied amid and  subnet ID.
  
 step-5: Attempt to format the files correctly
  
     terraform fmt
  
  you should see the error
  
  step-6:Edit the main.tf file to fix the error:
      
      vim main.tf
  
  step-7: Apply line numbering to the file so you can identify the           error more     easily:
      :set number
 
    step-8:Update line 25 as follows to correct the variable      
   interpolation error:
      Name = "${var.name}-learn"

    step-9:Write and quit to save your changes:
     :wq!

    step-10:Attempt to format the files again:
     terraform fmt
This time, you should be successful.

    step-11:Initialize your working directory:
     terraform 
  
  
Correct the Region Declaration Error
  
 step-1:Attempt to validate your Terraform configuration code:
      
      terraform validate 
 
step-2:Identify which file contains an error:
 
  Check the main.tf file.
  
       vim main.tf
  
  This file should not contain any errors.
 
  Check the terraform.tfvars file:
  
      vim terraform.tfvars
      
 You should see the variable regions, which is causing the error. This should instead be region.
Update regions to region in the variables.tf file to correct the region declaration error:
     variable "region" {
      
         description = 'The AWS region your resources will be deployed'

     }
  
 Correct the Syntax Error for the Resource
  
  step-1:Attempt to validate your Terraform configuration code again:
    
      terraform validate
  You should see another error.
      
     Edit the main.tf file:
     vim main.tf
Insert double quotes ("") around the ami and subnet_id values as follows to correct the syntax error:
      resource "aws_instance" "web_app"
         ami         = "ami-<YOUR_AMI_ID>"
         subnet_id   = "subnet-<YOUR_SUBNET_ID>"
Write and quit to save your changes:
:wq! 
  
Correct the Outputs Error
  
step-1:Attempt to validate your Terraform configuration code again:

      terraform validate
 
step-2:Edit the outputs.tf file:
      
       vim outputs.tf 

  step-3:Correct the first output error by changing the 
   instance_public_ip value from .public.ip to .pulic_ip as follows:
    
       output "instance_public_ip" {
          description = "Public IP address of the EC2 instance"
          value       = aws_instance.web_app.public_ip
        }

step-4:Correct the second output error by changing the instance_name    value from tag to tags as follows:
  
      output "instance_name" {
      
          description = "Tags of the EC2 instance"
  
           value       = aws_instance.web_app.tags.Name
       }
  
 Deploy the Infrastructure
  
step-1:Attempt to validate your Terraform configuration again:

     terraform validate
This time, you should be successful.

step-2:Apply your configuration:
  
    terraform apply
When prompted, type "yes" to confirm the apply.
    
  
