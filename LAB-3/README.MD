Using Terraform Provisioners to Set Up an Apache Web Server on AWS

 Clone Terraform Code and Switch to the Proper Directory
 
 step-1:Clone Terraform Code and Switch to the Proper Directory
 
         git clone https://github.com/linuxacademy/content-hashicorp-certified-terraform-associate-foundations.git
      
step-2:Switch to the directory where the code is located:

        cd content-hashicorp-certified-terraform-associate-foundations/section3-hol2/
        
step-3: List the files in the directory:

        ls
        
step-4: Examine the code in main.tf file 

       vim main.tf
       
       
       #Create and bootstrap webserver
      
      resource "aws_instance" "webserver" {
      
      ami                         = data.aws_ssm_parameter.webserver-ami.value
      
      instance_type               = "t3.micro"
     
     key_name                    = aws_key_pair.webserver-key.key_name
     
     associate_public_ip_address = true
     
     vpc_security_group_ids      = [aws_security_group.sg.id]
     
     subnet_id                   = aws_subnet.subnet.id
     
     provisioner "remote-exec" {
    
        inline = [
           
           "sudo yum -y install httpd && sudo systemctl start httpd",
           
           "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
          
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
 
 Deploy the Code and Access the Bootstrapped Webserver
 
 step-1: Initialize the Terraform working directory, and download the required providers:
 
      terraform init
      
 step-2: Validate the code to look for any errors in syntax, parameters, or attributes within Terraform resources that may prevent it from deploying correctly:
 
      terraform validate
      
step-3: Review the actions that will be performed when you deploy the Terraform code:

      terraform plan
      
step-4: Deploy code

      terraform apply
      
 step-5: When complete, it will output the public IP for the Apache webserver as the Webserver-Public-IP value.
      
  
 
 
