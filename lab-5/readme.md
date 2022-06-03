Exploring Terraform State Functionality

Check Terraform and Minikude Status

Step-1: Check the Terraform status using the version command

    terraform version

step-2: check the minikube status using 

     minikube status

it will return following

    minikube

    type: Control Plane

    host: Running 

    kubelet: Running 

    apiserver: Running 

    kubeconfig: Configured
    
Clone Terraform Code

step-1:  clone the terraform code using the comamnd git clone https://github.com/linuxacademy/content-hashicorp-certified-terraform-associate-foundations.git.

Switch to the directory where the code is located:       cd lab_code/section2-hol1/.

step-2: view the code in main.tf file

   vim main.tf
   
        provider "kubernetes" {
            config_path = "~/.kube/config"
        }
        resource "kubernetes_deployment" "tf-k8s-deployment" {
        metadata {
           name = "tf-k8s-deploy"
           labels = {
              name = "terraform-k8s-deployment"
           }
        }
        spec {
           replicas = 2

           selector {
             match_labels = {
               name = "terraform-k8s-deployment"
               }
             }
             template {
               metadata {
                 labels = {
                   name = "terraform-k8s-deployment"
                 }
              }
                spec {
                  container {          
		                  image = "nginx"         
		                  name  = "nginx"

                  }
                }
             }
          }
        }   
    

Deploy The Terraform Code

Initialize the working directory and download the required providers:

     terraform init

Review the actions that will be performed when you deploy the Terraform code using the command   
  
     terraform plan
  
deploy the command using

       terraform apply
       
Observe How the Terraform State File Tracks Resources

step-1: Once the code has executed successfully, list the files in the directory:

   ls

 Notice that the terraform.tfstate file is now listed. This state file tracks all the resources that Terraform has created.
 
 step-2:
 
 Optionally, verify that the pods required were created by the code as configured using

       kubectl:
   
       kubectl get pods
   
 There are currently 2 pods in the deployment
 
 step-3:
 
 List all the resources being tracked by the Terraform state file using the terraform  state command:
    
    terraform state list
 
  There are two resources being tracked: kubernetes_deployment.tf-k8s-deployment and kubernetes_service.tf-k8s-service.

step-4: View the replicas attribute being tracked by the Terraform state file using grep and the kubernetes_deployment.tf-k8s-deployment resource:

     terraform state show kubernetes_deployment.tf-k8s-deployment | egrep replicas


step-5: Open the main.tf file to edit it:

       vim main.tf
step-6: Change the integer value for the replicas attribute from 2 to 4.


step-7: Review the actions that will be performed when you deploy the Terraform code:

     terraform plan

In this case, 1 resource will change: the kubernetes_deployment.tf-k8s-deployment resource for which we have updated the replicas attribute in our Terraform code.

step-8: Deploy the code again:

      terraform apply

step-9: When prompted, type yes and press Enter.

step-10: Optionally, verify that the pods required were created by the code as configured:

    kubectl get pods

There are now 4 pods in the deployment.

step-11:View the replicas attribute being tracked by the Terraform state file again:

     terraform state show kubernetes_deployment.tf-k8s-deployment | egrep replicas

There should now be 4 replicas being tracked by the Terraform state file. It is accurately tracking all changes being made to the Terraform code.

Tear Down the Infrastructure

step-1:Remove the infrastructure you just created:

      terraform destroy

step-2:List the files in the directory:

      ls
Notice that Terraform leaves behind a backup file — terraform.tfstate.backup — in case you need to recover to the last deployed Terraform state.
