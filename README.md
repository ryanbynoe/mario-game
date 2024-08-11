# Table of Contents
- [Key Technologies](#keytechnologies)
- [Project Steps](#projectsteps)
- [Prerequisites](#prerequisites)
- [Walkthrough](#walkthrough)
- [Result](#result)
- [Challenges](#challenges)


## Key Technologies

- GitOps
- Kubernetes
- Terraform
- Azure Cloud (Azure Kubernetes Service)
- AWS
- GitHub Actions
- ArgoCD
- Docker
- Sonarqube


## Project Steps

1. Create infrastructure using Terraform in Azure and AWS.
2. Clone Mario game source code and implement GitOps pipeline steps using GitHub Actions.
3. Integrate Sonarqube for static code analysis (quality, security, vulnerabilities).
4. Dockerize the Mario game and push to Docker Hub.
5. Implement container scanning in the pipeline.
6. Create an Argo CD application for deployment to Kubernetes cluster.
7. Deploy the game on Azure Kubernetes Service (AKS).
8. Implement an end-to-end GitOps pipeline with CI/CD and security checks.
9. Make game control changes to test the pipeline's effectiveness.


# Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [AWS Account](https://aws.amazon.com/free/?trk=fce796e8-4ceb-48e0-9767-89f7873fac3d&sc_channel=ps&ef_id=Cj0KCQjwn9y1BhC2ARIsAG5IY-5E-SY7m8_H4a8ouDa76758jWiwTAq0UdWQWXXlz43VWT1TVmbWOfkaAt2nEALw_wcB:G:s&s_kwcid=AL!4422!3!592542020599!e!!g!!aws!1644045032!68366401852&gclid=Cj0KCQjwn9y1BhC2ARIsAG5IY-5E-SY7m8_H4a8ouDa76758jWiwTAq0UdWQWXXlz43VWT1TVmbWOfkaAt2nEALw_wcB&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
- [Azure Account](https://azure.microsoft.com/en-us/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Vscode](https://code.visualstudio.com)

# GitHub Repos Used
- Azure Infrastructure Terraform
    ```
    https://github.com/asecurityguru/gitops-aks-terraform-infra-repo
    ```
- ArgoCD Deployment on Azure Kubernetes Service(AKS)
    ```
    https://github.com/asecurityguru/gitops-aks-argocd-terraform-repo
    ```
- AWS EC2 with Docker and SonarQube Teraform
    ```
    https://github.com/asecurityguru/gitops-aws-ec2-terraform-repo

    ```
- Fork the Mario game
    ```
    https://github.com/asecurityguru/gitops-pipeline-supermario-repo

    ```
# Walkthrough

## Azure Infrastructure Terraform
Go to the terminal and authenticate with `az login` to login Azure account.
### Deployment Steps
1. Run `terraform init` to initialize and download required plugins (Azurerm).

![terraforminit](/assets/terraforminit.jpg)

2. Execute `terraform plan -var-file=./vars/east-us-2.tfvars` to preview resources to be created.

![terraformplan](/assets/terraformplan.jpg)

3. Run `terraform apply -var-file=./vars/east-us-2.tfvars` to create the AKS cluster.
4. Confirm the action by typing 'yes' when prompted.

![terraformapply](/assets/terraformapply.png)

## ArgoCD Deployment on Azure Kubernetes Service(AKS)

I currently have Kubectl installed. here are the installation steps:
1. Download kubectl for Windows from the official Kubernetes website: [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
2. Create a folder (e.g., `C:\kubectl_software`) and place the kubectl executable there.
3. Add the folder path to the system's Environment Variables.
4. Verify installation by running `kubectl` in Command Prompt.
Retrieves the credentials from the AKS cluster and merges to kubeconfig file.
```bash
az aks get-credentials --resource-group myAksResourceGroup --name myAksCluster

```
### Verify Cluster Connection
Use `kubectl cluster-info` to verify the connection to the AKS cluster.
![kubecluster](/assets/kubectlinfo.png)

### Install Base64 Extension for VS Code
1. Open VS Code Extensions marketplace.
2. Search for "Base64".
3. Install the Base64 extension.

![base64](/assets/base64.png)

### Caveat
- If kubectl is installed after opening VS Code, restart VS Code to refresh environment variables.

### Terraform Deployment Steps
These will be the same steps as Azure Terraform.
1. Run `terraform init` to initialize required providers.
2. Execute `terraform plan` to preview resources to be created.
3. Run `terraform apply` to deploy Argo CD on the AKS cluster.
![argocdtf](/assets/argocdterraform.png)
![akscluster](/assets/successcluster.png)

### Resources Created
- ArgoCD namespace
- ArgoCD installation in the ArgoCD namespace
- Load balancer for Argo CD

### Verification
1. Use `kubectl get svc -n argocd` to verify the created services.
2. Note the external IP of the Argo CD server load balancer.
3. Go to the external IP address, bypass by going to advanced, and proceed to IP. A certificate has not been established.

![argocdserver](/assets/argocdserver.png)
![argocdapp](/assets/argocdsuccess.png)

### Logging into Argo CD
1. Default username: `admin`
2. To get the default password, run:
   ```
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```
![password](/assets/base64pass.png)

3. Decode the base64 password. paste the base64 password in a text file in VS. Select the password, right click into base64, and press base64 decode. (Install VS Code Base64 extension).
4. Log in to the Argo CD dashboard using these credentials.

![argocsignin](/assets/argosignsuccess.png)

### AWS EC2 with Docker and SonarQube Teraform

### 1. Locate and Update VPC ID
1. Log in to AWS Console
2. I used region us-east-2 because I had a VPC already setup. The repo uses us-west-2.
3. Navigate to VPC service
4. Find the VPC ID you want to use
5. Copy the VPC ID
6. Update the `vpc_id` variable in `vars/dev-west-2.tfvars` file if using from repo. If using mine, update the `vars/east-us-2.tfvars`

### 2. Generate and Configure AWS Key Pair
1. In AWS Console, navigate to EC2 service
2. Go to "Key Pairs" under Network & Security
3. Click "Create Key Pair"
4. Name the key pair (lowercase) (e.g., "awsterraformkey")
5. Download the .pem file
6. Place the downloaded .pem file in the root of your Terraform project directory
7. Update the `key_name` variable in `vars/dev-west-2.tfvars` file with the name of your key pair (without the .pem extension)

### Verify
- Ensure the VPC ID is correctly updated in `vars/dev-west-2.tfvars` or `vars/east-us-2.tfvars`
- Confirm the key pair .pem file is in the root directory of your project
- Verify the key name is correctly updated in `vars/dev-west-2.tfvars` or `vars/east-us-2.tfvars`

### Terraform Deployment Steps
1. Run `terraform init` to initialize working directory.
    - This will create a Terraform lock file and install the AWS provider plugin.
2. Execute `terraform plan` to preview resources to be created.
    - `terraform plan -var-file= "vars/dev-west-2.tfvars"`
    - or `terraform plan -var-file= "vars/east-us-2.tfvars"`
3. Run `terraform apply` to deploy Argo CD on the AKS cluster.
    - `terraform apply -var-file= "vars/dev-west-2.tfvars"`
        or `terraform apply -var-file= "vars/east-us-2.tfvars"`
4.    
    - Type 'yes' when prompted to confirm resource creation.
   - This will create an EC2 instance and attach a security group to it.
   - Docker and SonarQube will be deployed on the EC2 instance.

### Verifying the Infrastructure
4. Check the AWS Console:
   - Go to EC2 service
   - Verify the created instance named "SonarQube instance"
   - Check the security group attached to the instance (ports 22 and 9000 should be open)

5. Access SonarQube:
   - Copy the public IP address of the EC2 instance
   - Open a web browser and navigate to `http://<EC2-Public-IP>:9000`
   - Default login credentials: username `admin`, password `admin`
   - You will be prompted to change the password on first login

![ec2](/assets/sonarqrunning.png)
![sg](/assets/sonarqubesg.png)
![ec22](/assets/sonarqpage.png)



# Challenges

Error with Microsoft.ContainerService. Resolution: Confirming my subscription had the service registered.
![challenge1](/assets/challenge1error.png)
![challenge1](/assets/challengge1.jpg)




