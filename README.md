# Deploy Mario Game with GitOps Practices!
![mario](/assets/marioproject.gif)
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

# THE FUN: Super Mario Game Deployment!

### Setup Steps for SonarQube Integration

1. Fork Super Mario game GitHub repo and the clone.
2. Open repo in Visual Studio Code 

### YAML File Structure (`.github/workflows/gitops.yaml`)
Inside the new gitops.yaml:
```yaml
name: Run SAST scan on Super Mario Game Project

on:
  push:
    branches:
      - main

jobs:
  sonarqube-sast-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

4. **Steps**:
   - **Checkout Repository**: Uses `actions/checkout@v3` to fetch the repository code.
     - `fetch-depth: 0` ensures all history for all branches and tags is fetched.
   - **SonarQube Scan**: Uses `sonarsource/sonarqube-scan-action@master` to run the scan.
     - Requires two environment variables:
       - `SONAR_HOST_URL`: URL of your SonarQube instance.
       - `SONAR_TOKEN`: Authentication token for SonarQube.
       - The two environment variables will be set up in Github actions.

### Creating a SonarQube Project

1. Log in to SonarQube dashboard
2. Click on "Create project manually"
3. Set project display name (e.g., "devsecops-pipeline")
4. Note down the project key
5. Set the main branch name (e.g., "main" or "master")
6. Choose GitHub Actions integration

![s1](/assets/sonarqj1.png)
![s2](/assets/sonarqj2.png)

### Generating SonarQube Token
1. Click on "Generate a token"
2. Set token expiration (or choose "No expiration")
3. Generate and copy the token (it will be shown only once)
![s3](/assets/sonarqj3.png)

### Creating sonar-project.properties File
1. Create a file named `sonar-project.properties` in the root of your repository
2. Add the following content:
   ```
   sonar.projectKey=devsecops-pipeline
   ```
   Replace `devsecops-pipeline` with your actual project key

### Setting Up GitHub Repository Secrets
1. Go to your GitHub repository settings
2. Navigate to Secrets and Variables > Actions
3. Add two new repository secrets:
   - Name: `SONAR_HOST_URL`
     Value: Your SonarQube instance URL
   - Name: `SONAR_TOKEN`
     Value: The token generated in SonarQube
![s4](/assets/githubactions.png)

### Final Steps
1. Ensure all files are committed:
   - `.github/workflows/gitops.yaml`
   - `sonar-project.properties`
2. Push the changes to your GitHub repository

### Pushing Code to GitHub
1. Open a command prompt in your local repository
2. Check status of changes: `git status`
3. Add all changes: `git add *`
4. Commit changes: `git commit -m "Added SonarQube SAST scan GitHub action to pipeline"`
5. Push changes: `git push`

### Verifying GitHub Action Execution
1. Go to your GitHub repository
2. Click on the "Actions" tab
3. You should see a workflow run named "Run SAST scan on Super Mario Game Project"
4. Click on the workflow run to see details
5. Expand the "SonarQube Scan" step to see execution details

![gh](/assets/githubactionspush.png)
![gh2](/assets/githubactionspushsuccess.png)
![gh3](/assets/guthubactionssteps.png)

### Viewing SonarQube Results
1. Log in to your SonarQube dashboard
2. Go to the "Projects" tab
3. Click on your project name to see detailed results
4. Review different categories of issues:
   - Bugs
   - Vulnerabilities
   - Security Hotspots
   - Code Smells
   - Duplications

![gh3](/assets/sonarqpipelinestatus.png)

### Understanding SonarQube Ratings
- SonarQube assigns ratings (A to E) for different issue types based on their severity and quantity
- Review ratings for security, reliability, and maintainability

### GitHub Actions Workflow File
- You can view and edit the workflow file directly in GitHub
- Navigate to `.github/workflows/gitops.yaml` in your repository

## Setting Up Docker Hub
1. Go to [Docker Hub](https://hub.docker.com/)
2. Click on the "Sign Up" option
3. You can sign up using Google, GitHub, or directly with an email
4. If using Google, select your Google account and click "Continue"
5. Enter a username 
6. Click the "Sign Up" button
7. Your Docker Hub account is now created successfully

## Creating a Docker Hub Repository
1. Log in to your Docker Hub account
2. Click on your profile icon to view your account details
3. Click on the "Create Repository" option
4. Choose "Public" for the repository visibility
   - Public repos appear in Docker Hub search results
   - Private repos are only visible to you
5. Provide a repository name (e.g., "Super Mario GitOps Project")
6. Click the "Create" button
7. Your repository is now created under your Docker Hub username

### File: `GitOps-build-push-super-mario-image.yaml`
* Please note to update to your dockerhub repository: docker.io/[insert docker repo]:${{ env.VERSION }} 
```yaml
name: "Build and push Super Mario Docker image with dynamic tag to Docker Hub"
 
on:
  push:
    branches:
      - main
 
env:
  VERSION: $(( $(cat version.txt) + 1 ))
  
jobs:
  
  build_push_supermario_docker_image:
    runs-on: ubuntu-latest
 
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
   
      - name: Login to Docker Hub
        run: echo "${{ secrets.DOCKERHUB_TOKEN }}" | docker login -u "${{ secrets.DOCKERHUB_USERNAME }}" --password-stdin
 
      - name: Build and Push Docker Image

        run: |
          docker build -t docker.io/ryanabynoe/supermarioproject:${{ env.VERSION }} .
          docker push docker.io/ryanabynoe/supermarioproject:${{ env.VERSION }}
```

### Updating GitHub Actions Workflow
1. Rename `gitops.yaml` to `gitops-sast-sonar.yaml`
2. Create a new file `gitops-build-push-super-mario-image.yaml`
3. Update the workflows as needed (e.g., commenting out triggers in the SAST workflow)

### File: `GitOps-sast-sonar.yaml`
```yaml
name: "Run SAST Scan on SuperMario Game Project"

on:
  push:
    branches:
      - main
  
jobs:

  sonarqube_sast_scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Shallow clones should be disabled for better analysis relevance

      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_HOST_URL: ${{secrets.SONAR_HOST_URL}}
          SONAR_TOKEN: ${{secrets.SONAR_TOKEN}}
      # If you wish to fail your job when the Quality Gate is red, uncomment the
      # following lines. This would typically be used to fail a deployment.
      # - name: SonarQube Quality Gate Check
      #   uses: sonarsource/sonarqube-quality-gate-action@master
      #   timeout-minutes: 5
      #   env:
      #     SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
 ```

1. In your GitHub repository, go to Settings > Secrets and add the following repository secrets:
   - `DOCKER_HUB_TOKEN`: Your Docker Hub access token
   - `DOCKER_HUB_USERNAME`: Your Docker Hub username
2. Push changes to the main branch to trigger the workflow

### Creating Docker Hub Access Token
1. Log in to Docker Hub
2. Go to My Account > Security
3. Click on "New Access Token"
4. Provide a description (e.g., "GitHub GitOps practice")
5. Set permissions to "Read, Write, Delete"
6. Generate and copy the token

### Pushing Changes and Running the Workflow
1. Commit and push the changes to GitHub
2. Go to the Actions tab in your GitHub repository
3. Verify that the new workflow "Build Push Super Mario Docker Image" runs successfully

### Verifying Docker Image Push
1. Check the GitHub Actions logs for successful build and push steps
2. Log in to Docker Hub and navigate to your repository
3. Verify that the new image is present with the correct tag (e.g., "1")

### Docker Image Details
- Repository: `[Your Docker Hub Username]/super-mario-gitops-project`
- Initial Tag: "1" (static)
- Image contains labels and metadata as defined in the Dockerfile

## Implementing Dynamic Docker Image Tagging

### Steps to Implement Dynamic Tagging
1. Add a `version.txt` file at the root of the repository
   - Initially contains the value "1"

2. Update the GitHub Actions workflow file
   - Create an environment variable `VERSION` that reads from `version.txt` and increments by 1
   - Use this `VERSION` variable when building and pushing the Docker image

3. Push changes to the GitHub repository

### Workflow File Changes
```yaml
jobs:
  build-push-super-mario-docker-image:
    runs-on: ubuntu-latest
    steps:
      # ... (previous steps)
      
      - name: Generate Image Tag
        run: |
          echo "VERSION=$(($(cat version.txt) + 1))" >> $GITHUB_ENV
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/super-mario-gitops-project:${{ env.VERSION }}
```
### Verifying Dynamic Tagging
1. Check the GitHub Actions logs to see the new tag being used
2. Verify in Docker Hub that a new image with the incremented tag has been pushed

### Current Limitation
The current implementation doesn't update the `version.txt` file after pushing a new image. This means subsequent runs will always increment from the original value in `version.txt`.

### Steps to Implement Container Scanning
1. Create a new GitHub Actions workflow file: `run-container-scan-super-mario-image.yaml`
2. Push the code to the remote GitHub repository

```yaml
name: Run Container Scan on Super Mario Docker Image with Quality Gate

on:
  push:
    branches:
      - main

env:
  VERSION: ${{ github.run_number }}

jobs:
  run-container-image-scan-on-super-mario-docker-image:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Get Docker image from Docker Hub
        run: |
          docker pull ${{ secrets.DOCKERHUB_USERNAME }}/super-mario-gitops-project:${{ env.VERSION }}
          docker save -o ${{ github.workspace }}/super-mario-latest-docker-image.tar ${{ secrets.DOCKERHUB_USERNAME }}/super-mario-gitops-project:${{ env.VERSION }}

      - name: Run Trivy vulnerability scanner in tarball mode
        uses: aquasecurity/trivy-action@master
        with:
          input: ${{ github.workspace }}/super-mario-latest-docker-image.tar
          format: 'table'
          exit-code: '1'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'
```
### Key Components
1. **Docker Hub Authentication**: Uses secrets for secure login
2. **Image Pulling**: Pulls the latest Super Mario image from Docker Hub
3. **Image Saving**: Saves the pulled image as a tar file
4. **Trivy Scanner**: Runs a vulnerability scan on the saved image
   - Exit code 1: Fails the build if critical or high vulnerabilities are found
   - Exit code 0: Allows the build to pass regardless of vulnerabilities (for testing)\

### Pushing and Executing the Workflow
1. Move the YAML file to the `.github/workflows/` directory
2. Commit and push changes to the GitHub repository
   ```
   git add .
   git commit -m "Added container scan with quality gate in DevSecOps pipeline while learning GitOps principles"
   git push
   ```
3. Observe the workflow execution in the GitHub Actions tab

### Modifying the Workflow to Pass Despite Vulnerabilities
1. Change the exit code in the YAML file from 1 to 0
2. Commit and push the changes
   ```
   git add .
   git commit -m "Pass the DevSecOps pipeline even if there are security vulnerabilities in Docker image"
   git push
   ```
3. Observe the new workflow execution

### Setting Up Argo CD Application

1. Log in to Argo CD dashboard
2. Click on "New App" button
3. Configure the application:
   - Application Name: `super-mario-game-deployment` (use lowercase)
   - Project Name: `default`
   - Sync Policy: Select "Automatic"
   - Source:
     - Repository URL: [Your GitHub Repo URL]
     - Revision: `HEAD`
     - Path: `.` (period symbol for root directory)
   - Destination:
     - Cluster URL: Select the default Kubernetes cluster URL
     - Namespace: `default` (or your preferred namespace)
4. Click "Create" to create the application

![ag](/assets/supermarioappargo.png)
![ag2](/assets/supermarioappargo2.png)
![ag3](/assets/supermarioappargo3.png)
![ag4](/assets/supermarioappargo4.png)

### Key Points
- Auto-sync is enabled by default with this configuration
- Argo CD checks for changes every 3 minutes
- Any changes in the `deployment.yaml` file will trigger a new deployment

### Creating the Deployment YAML File
1. Create a file named `deployment.yaml` in the root of your GitHub repository
2. Add the following content to the file:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: supermariogame-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: supermariogame
  template:
    metadata:
      labels:
        app: supermariogame
    spec:
      containers:
      - image: ryanabynoe/supermarioproject:2
        name: supermariogame-container
        ports:
        - containerPort: 8080
 
---
apiVersion: v1
kind: Service
metadata:
  name: supermariogame-service
spec:
  selector:
    app: supermariogame
  ports:
  - protocol: TCP
    port: 8600  # <-- Change this line to your desired port
    targetPort: 8080
  type: LoadBalancer
```
### Verifying the Deployment
1. Check Argo CD dashboard for the new deployment
2. Verify the pod creation in Argo CD
3. Check the load balancer service created by Argo CD

![agdep](/assets/argocddeployment.png)


### Accessing the Super Mario Game
1. Copy the load balancer IP address from the Argo CD service details
2. Open a new browser tab and navigate to `http://<load-balancer-ip>:8600`
3. The Super Mario game should load in the browser

![ag4](/assets/supermarioloadbalancer.png)

### Playing the Game
- Press 'Y' to start the game
- Use arrow keys to navigate
- Press 'S' for jump and other gameplay moves

![mario](/assets/mariogamedeployed.png)

### Pushing Changes and Waiting for Argo CD
1. Commit and push the `deployment.yaml` file to your GitHub repository
2. Wait for approximately 3 minutes for Argo CD to detect the changes

## Implementing End-to-End GitOps Pipeline

### Steps Overview
1. Make code changes to Super Mario game controls
2. Add end-to-end GitOps YAML file for GitHub Actions
3. Set up repository secrets in GitHub
4. Push changes to remote GitHub repository
5. Verify new Docker image tag in Docker Hub
6. Check for updated version in version.txt and deployment.yaml
7. Wait for Argo CD to detect and deploy changes
8. Verify new game controls in deployed Super Mario game

### 1. Code Changes
- Update `webapp/code/titlestate.js` file
- Change "Press Y to start game" to "Press S to start"
- Modify game controls to use 'S' key consistently

### 2. Adding End-to-End GitOps YAML File
- Create `end-to-end-gitops.yaml` in `.github/workflows/` directory
- Add workflow code for:
  - Static application security testing with SonarQube
  - Building and pushing Docker image with dynamic tag
  - Running container scan
  - Updating deployment and version files

### 3. Setting Up Repository Secrets
Ensure the following secrets are set in GitHub repository:
- `DOCKERHUB_TOKEN`
- `DOCKERHUB_USERNAME`
- `SONAR_HOST_URL`
- `SONAR_TOKEN`
- `GIT_EMAIL`
- `GIT_USERNAME`

### Prerequisites
- Ensure SonarQube is running
- Verify all repository secrets are correct (SonarQube URL, tokens, Docker Hub credentials, Git email and username)

### Workflow Execution Steps

1. **Code Commit and Push**
   - Commit changes including the end-to-end GitOps YAML file and game control modifications
   - Push changes to the GitHub repository

2. **SonarQube SAST Scan**
   - Successfully executed
   - Results viewable in SonarQube dashboard
   - Identified code smells, bugs, and security hotspots

3. **Docker Image Build and Push**
   - New image tag (3) automatically generated
   - Image successfully pushed to Docker Hub

4. **Container Image Scan**
   - Trivy scanner identified 40 vulnerabilities (36 high, 4 critical)

5. **Update Deployment Files**
   - `deployment.yaml` and `version.txt` updated with new image tag (3)
   - Changes automatically committed and pushed to the repository

6. **Argo CD Sync**
   - Detected changes after approximately 3 minutes
   - Automatically deployed new image to Azure Kubernetes Service

### Verification
1. Check Argo CD dashboard for successful sync
2. Verify pod details in Argo CD showing new image tag
3. Access the Super Mario game via load balancer URL
4. Confirm new game controls (S key) and updated start screen text

### Results
- Entire pipeline execution completed in about 2 minutes
- Continuous Integration, Security, and Deployment achieved
- Changes successfully reflected in the deployed application

### Key Observations
- No manual intervention required after initial code push
- GitHub maintained as single source of truth
- Automated security scanning and deployment processes

## Cleaning Up Resources

### Destroying Argo CD and Related Resources

1. Navigate to the GitOps, AKS, Argo CD, Terraform repository

2. Run the Terraform destroy command:
   ```
   terraform destroy -var-file=./vars/dev-west-2.tfvars
   ```

3. Review the resources to be destroyed:
   - Argo CD namespace
   - Argo CD installation
   - Load balancer for Argo CD

4. Confirm the destruction by typing 'yes' when prompted

5. Wait for Terraform to complete the resource destruction (approximately 35 seconds)

### Verification Steps

1. Check for any remaining services in the Argo CD namespace:
   ```
   kubectl get svc -n argocd
   ```
   Expected result: No resources found

2. Verify the deletion of the Argo CD namespace:
   ```
   kubectl get namespaces
   ```
   Expected result: Argo CD namespace should not be listed

### Important Notes
- Always destroy Argo CD related resources before destroying the Azure Kubernetes cluster
- This cleanup process ensures that all resources created by Terraform are properly removed
- Verify the absence of resources after the destroy command to ensure complete cleanup

## Cleaning Up Azure Cloud Resources

### Important Note
Always clean up resources to avoid unnecessary charges in your Azure Cloud account.

### Using Terraform Destroy

1. Navigate to the GitOps AKS Terraform infra repository

2. Run the Terraform destroy command:
   ```
   terraform destroy -var-file=./vars/dev-west-2.tfvars
   ```

3. Review the resources to be destroyed:
   - Kubernetes cluster
   - Cluster node pool (user pool)
   - Resource group

4. Confirm the destruction by typing 'yes' when prompted

5. Wait for Terraform to complete the resource destruction (approximately 10 minutes)

### Resources Destroyed by Terraform
- User node pool (~ 1 minute)
- AKS cluster (~ 2 minutes)
- AKS resource group

### Manual Cleanup
1. Check the Azure Portal "All resources" section for any remaining resources
2. Manually delete any resources not removed by Terraform

### Verification
- Refresh the Azure Portal to confirm all resources have been removed

### Important Notes
- Some dependent or transitive resources may not be cleaned up automatically by Terraform
- Always verify in the Azure Portal that all resources have been deleted
- Be prepared to manually delete any lingering resources to ensure complete cleanup

## Cleaning Up AWS Infrastructure

### Using Terraform Destroy

1. Run the Terraform destroy command with the appropriate variable file:
   ```
   terraform destroy -var-file=./vars/east-us-2.tfvars
   ```

2. Review the resources to be destroyed:
   - AWS EC2 instance
   - Security group attached to the EC2 instance

3. Confirm the destruction by typing 'yes' when prompted

4. Wait for Terraform to complete the resource destruction

### Resources Destroyed by Terraform
- AWS EC2 instance
- Security group attached to the EC2 instance

### Verification
1. Check the AWS Console to confirm the EC2 instance state has changed to "terminated"
2. Refresh the AWS Console to ensure no instances are running

### Important Notes
- Always clean up resources at the end of the course to avoid unnecessary charges in your AWS account
- Verify in the AWS Console that all resources have been properly terminated
- The Terraform destroy command should remove both the EC2 instance and its associated security group

### Final Step
Ensure all resources created for this course are destroyed to prevent any unexpected AWS charges.

# Challenges

Error with Microsoft.ContainerService. Resolution: Confirming my subscription had the service registered.
![challenge1](/assets/challenge1error.png)
![challenge1](/assets/challengge1.jpg)

# Credits

Raghu The Security Expert
Udemy: www.udemy.com/course/gitops-with-kubernetes-terraform-azure-and-aws/


