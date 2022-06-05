Using Terraform CLI Commands (workspace and state) to Manipulate a Terraform Deployment
Clone Terraform Code and Switch to the Proper Directory
  
step-1:Clone the required code from the provided repository:

    git clone https://github.com/linuxacademy/content-hashicorp-certified-terraform-associate-foundations.git

step-2:Switch to the directory where the code is located:

      cd content-hashicorp-certified-terraform-associate-foundations/section4-lesson3/

step-3:List the files in the directory:

     ls

The files in the directory should include main.tf and network.tf. These files basically use the ${terraform.workspace} variable to create parallel environments and decide which region the deployment occurs in, depending on the workspace you're in.

Create a New Workspace

step-1:Check that no workspace other than the default one currently exists:

    terraform workspace list

step-2:Create a new workspace named test, using the command terraform workspace new test.

You will be automatically switched into the newly created test workspace upon successful completion. Confirm this using the terraform workspace list command.

Deploy Infrastructure in the Test Workspace and Confirm Deployment via AWS

step-1:In the test workspace, initialize the working directory and download the required providers:

     terraform init
     
step-2:View the contents of the main.tf file using the cat command:

     cat main.tf

     provider "aws" {
        region = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
     }

     #Get Linux AMI ID using SSM Parameter endpoint in us-east-1
     data "aws_ssm_parameter" "linuxAmi" {
        name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
     }

     #Create and bootstrap EC2 in us-east-1
     resource "aws_instance" "ec2-vm" {
         ami                         = data.aws_ssm_parameter.linuxAmi.value
         instance_type               = "t3.micro"
         associate_public_ip_address = true
         vpc_security_group_ids      = [aws_security_group.sg.id]
         subnet_id                   = aws_subnet.subnet.id
         tags = {
            Name = "${terraform.workspace}-ec2"
         }
    }
    
step-3:Note the configurations in the main.tf code, particularly:

AWS is the selected provider.

If the code is deployed on the default workspace, the resources will be deployed in the us-east-1 region.


If the code is deployed on any other workspace, the resources will be deployed in the us-west-2 region.

In the code creating the EC2 virtual machine, we have embedded the $terraform.workspace variable in the Name attribute, so we can easily distinguish those resources when they are created within their respective workspaces by their name: <workspace name>-ec2.

step-4:View the contents of the network.tf file:

  
     cat network.tf

step-5:Note the configurations in the network.tf code, particularly:

In the code creating the security group resource, we have embedded the $terraform.workspace variable in the Name attribute, so we can easily distinguish those resources when they are created within their respective workspaces by their name: <workspace name>-securitygroup.

step-6:Deploy the code in the test workspace:

      terraform apply --auto-approve
  
step-7:Once the code has executed successfully, confirm that Terraform is tracking resources in this workspace:

       terraform state list

  There should be a number of resources being tracked, including the resources spun up by the code just deployed.

step-8:Switch over to the default workspace:

       terraform workspace select default

step-9:Confirm that Terraform is currently not tracking any resources in this workspace, as nothing has been deployed:

      terraform state list

  The return output should say that No state file was found! for this workspace.

step-10:Verify that the deployment in the test workspace was successful by viewing the resources that were created in the AWS Management Console:

Navigate to the AWS Management Console in your browser.
Click on N. Virginia (the us-east-1 region) at the top-right to engage the Region drop-down, and select US West (Oregon), or us-west-2.
Expand the Services drop-down and select EC2.
On the Resources page, click Instances.
Verify that the test-ec2 instance appears in the list.
In the menu on the left, click Security Groups.
Verify that the test-securitygroup resource appears in the list.
  
Deploy Infrastructure in the Default Workspace and Confirm Deployment via AWS
  
step-1:Back in the CLI, verify that you are still within the default workspace:

     terraform workspace list

  Again, the asterisk (*) prepended to the name confirms you are in the default workspace.

Deploy the code again, this time in the default workspace:

     terraform apply --auto-approve
Once the code has executed successfully, confirm that Terraform is now tracking resources in this workspace:

     terraform state list
There should now be a number of resources being tracked, including the resources spun up by the code just deployed.

Verify that the deployment in the default workspace was successful by viewing the resources that were created in the AWS Management Console:

Navigate to the AWS Management Console in your browser.
Click on Oregon (the us-west-2 region) at the top-right to engage the Region drop-down, and select US East (N. Virginia), or us-east-1.
As you are already on the Security Groups page, verify that the default-securitygroup resource appears in the list.
In the menu on the left, click Instances.
Verify that the default-ec2 instance appears in the list.
  
  
Destroy Resources in the Test Workspace and Delete the Workspace
  
step-1:Back in the CLI, switch over to the test workspace:

    terraform workspace select test

  step-2:Tear down the infrastructure you just created in the test workspace:

     terraform destroy --auto-approve

  step-3:Verify that the resources were terminated in the AWS Management Console:

Navigate to the AWS Management Console in your browser.
Click on N. Virginia (the us-east-1 region) at the top-right to engage the Region drop-down, and select US West (Oregon), or us-west-2.
As you are already on the Instances page, verify that the test-ec2 instance is shutting down or may have already been terminated.
In the menu on the left, click Security Groups.
Verify that the test-securitygroup resource no longer appears in the list.

step-4:Back in the CLI, switch over to the default workspace:

     terraform workspace select default

  step-5:Delete the test workspace:

     terraform workspace delete test

  step-6:Tear down the infrastructure you just created in the default workspace before moving on:

    terraform destroy --auto-approve
