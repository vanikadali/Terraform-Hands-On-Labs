Practicing Terraform CLI Commands (fmt, taint, and import)

Clone Terraform Code and Switch to the Proper Directory

step-1: Clone the required code from the provided repository:

     git clone https://github.com/linuxacademy/content-hashicorp-certified-terraform-associate-foundations.git

step-2:Switch to the directory where the code is located:

  cd content-hashicorp-certified-terraform-associate-foundations/section4-hol1
  
Use the fmt Command to Format Any Unformatted Code Before Deployment

step-1: View the contents of the main.tf file using the cat command:

   cat main.tf
   
   ![image](https://user-images.githubusercontent.com/103553658/172042147-28082947-b99b-4c6e-a123-c3d76fabe057.png)

Notice that the code in the file is pretty messy and improperly formatted, with issues like inconstent indentation, which is making it hard to read.

step-2: Use the terraform fmt command to format the code in any file in the directory in which Terraform finds formatting issues:

    terraform fmt
    
Once the command has completed, note that Terraform returns the output main.tf, which means that Terraform found formatting issues in that file and has gone ahead and fixed those formatting issues for you.


step-3: View the contents of the the main.tf file again:

 cat main.tf
 ![image](https://user-images.githubusercontent.com/103553658/172042239-75f8c1e2-f954-4435-a4c5-5038f5ec65e1.png)
    
    Notice that the code has now been formatted cleanly and consistently.

step-4: Initialize the Terraform working directory and fetch any required providers:

     terraform init
     
step-5:Deploy the code:

     terraform apply
     
     
Use the taint Command to Replace a Resource

Modify the Provisioner Code for the aws_instance.webserver Resource

step-1:Using Vim, open the main.tf file:

     vim main.tf
     
     
     #Create and bootstrap webserver
     resource "aws_instance" "webserver" {
         ami                         = data.aws_ssm_parameter.webserver-      ami.value
         instance_type               = "t3.micro"
         key_name                    = aws_key_pair.webserver-key.key_name
         associate_public_ip_address = true
         vpc_security_group_ids      = [aws_security_group.sg.id]
         subnet_id                   = aws_subnet.subnet.id
         provisioner "remote-exec" {
             inline = [
                "sudo yum -y install httpd && sudo systemctl start httpd",
                "echo '<h1><center>My Website via Terraform Version 1</center></h1>' > index.html",
                "sudo mv index.html /var/www/html/"
                 ]
                 connection {
                    type        = "ssh"
                    user        = "ec2-user"
                    private_key = file("~/.ssh/id_rsa")
                    host        = self.public_ip
                 }
              }
              tags = {
                 Name = "webserver"
              }
            }


step-2:Note the name of the resource that is created by this code; in this case, it would be aws_instance.webserver as configured.

step-3:Inside the provisioner block, find the following line of code that outputs the content on a webpage, which currently displays Version 1:

     echo '<h1><center>My Website via Terraform Version 1</center></h1>'
     
In this line of code, change Version 1 to Version 2.

Taint the Existing aws_instance.webserver Resource

step-1:Use the terraform taint command and the name of the resource to tell Terraform to replace that resource and run the provisioner again upon the next deployment:

    terraform taint aws_instance.webserver

step-2:View the Terraform state file to verify that the resource has been tainted:

    vim terraform.tfstate
    
 Search for the keyword /taint and notice that the aws_instance resource with the name webserver has a status of tainted.
 
 Deploy the Code to Rerun the Provisioner and Replace the aws_instance.webserver Resource
 
 step-1: Deploy the code
 
     terraform apply
     
step-2:In the plan that displays before deployment, note that it will add 1 resource and destroy 1 resource, which is in essence the replacement of the old aws_instance.webserver with the new aws_instance.webserver that is configured with the modified code. Note also that it outputs a change to the public IP of the resource via the Webserver-Public-IP value

step-3;When complete, it will output the new public IP for the webserver as the Webserver-Public-IP value.

step-4:Use the curl command to view the contents of the webpage using the IP address provided:

       curl http://<WEBSERVER-PUBLIC-IP>

In the output that is returned, verify that it returns My Website via Terraform Version 2, validating that the provisioner was successfully run again and the tainted resource (which contained code for Version 1) was replaced with a new resource (which contained code for Version 2).

Use the import Command to Import a Resource

Add the VM as a Resource Named aws_instance.webserver2 in Your Code

step-1:View the contents of the resource_ids.txt file:

      cat /home/cloud_user/resource_ids.txt
      
step-2:Copy the EC2 instance ID that is displayed in the contents of the file.

step-3:Open the main.tf file to modify it:

   vim main.tf

 step-4:At the bottom of the code, insert a new line and add the associated resource that will be named aws_instance.webserver2 into your main Terraform code:

     resource "aws_instance" "webserver2" {
         ami = data.aws_ssm_parameter.webserver-ami.value
         instance_type = "t3.micro"
      }
      
Import the aws_instance.webserver2 Resource to Your Terraform Configuration

step-1:Use the terraform import command, the name of the resource in your main code, and the EC2 instance ID to tell Terraform which resource to import:

      terraform import aws_instance.webserver2 <COPIED-EC2-INSTANCE-ID>
      
step-2:View the Terraform state file to verify that the resource has been imported:

     vim terraform.tfstate

step-3:Search for the keyword /webserver2 and notice that the aws_instance resource with the name webserver2 is listed and has a mode of managed.

Modify the aws_instance.webserver2 Resource

step-1:Open the main.tf file to modify it:

     vim main.tf

step-2:At the bottom of the file, replace the existing code for the aws_instance.webserver2 resource with the following:

      resource "aws_instance" "webserver2" {
          ami = data.aws_ssm_parameter.webserver-ami.value
          instance_type = "t3.micro"
          subnet_id = aws_subnet.subnet.id
      }
      
      
step-3:As a best practice, format the code before deployment:

      terraform fmt
step-4:Deploy the updated code:

     terraform apply

step-5:In the plan that displays before deployment, note that it will add 1 resource and destroy 1 resource, which is in essence the replacement of the old aws_instance.webserver2 with the new aws_instance.webserver2 that is configured with the modified code. You can also scroll up in the plan and verify that aws_instance.webserver2 will be replaced.


In the output that is returned, verify that 1 resource was added and 1 was destroyed, validating that the old aws_instance.webserver2 resource was replaced with the new aws_instance.webserver2 containing your customized code.
