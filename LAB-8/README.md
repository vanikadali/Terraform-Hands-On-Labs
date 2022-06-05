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
