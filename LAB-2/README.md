installing Terraform and Working with Terraform Providers

step-1: Download And Manually Install the Terraform Binary by using following steps
    2  sudo apt update
    3  sudo apt-get install unzip
    4  wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
    5  unzip terraform_1.0.7_linux_amd64.zip
    6  sudo mv terraform /usr/local/bin/
    7  terraform --version
    
step-2: Clone Over Code for Terraform Providers
Create a provider directory:

     mkdir provider

Move to the providers directory, using the command
   
      cd providers

Create a file main.tf and paste the following code:

      vim main.tf
      
      provider "aws" {
         alias  = "us-east-1"
         region = "us-east-1"
      }

     provider "aws" {
        alias  = "us-west-2"
        region = "us-west-2"
     }


     resource "aws_sns_topic" "topic-us-east" {
        provider = aws.us-east-1
        name     = "topic-us-east"
     }

    resource "aws_sns_topic" "topic-us-west" {
     provider = aws.us-west-2
     name     = "topic-us-west"
    }
    

step-4: Deploy the code

Initialize the working directory using the command
   
      terraform init


Review the actions performed using the command 
    
     terraform plan
     
deploy the code using
  
     terraform apply



