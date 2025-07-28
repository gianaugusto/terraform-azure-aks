# Terraform Azure AKS Deployment

This project provides a Terraform configuration to deploy a Docker image to Azure Kubernetes Service (AKS) and expose it publicly using Azure API Management (APIM) with authentication.

## Prerequisites

- Azure CLI installed and configured.
- Terraform installed.
- Docker installed.

## Setup

1. **Install Azure CLI**:
   - Follow the instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to install the Azure CLI.

2. **Install Terraform**:
   - Follow the instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform.

3. **Install Docker**:
   - Follow the instructions [here](https://docs.docker.com/get-docker/) to install Docker.

## Configuration

1. **Login to Azure CLI**:
   ```sh
   az login
   ```

2. **Set your Azure subscription**:
   ```sh
   az account set --subscription "your-subscription-id"
   ```

3. **Initialize Terraform**:
   ```sh
   terraform init
   ```

4. **Deploy the infrastructure**:
   ```sh
   terraform apply
   ```

5. **Deploy the Docker image to AKS**:
   - Build your Docker image and push it to the Azure Container Registry (ACR) created by Terraform.
   ```sh
   docker build -t your-image-name .
   az acr login --name aksacr
   docker tag your-image-name aksacr.azurecr.io/your-image-name
   docker push aksacr.azurecr.io/your-image-name
   ```

6. **Deploy the Docker image to AKS**:
   - Create a Kubernetes deployment YAML file (e.g., `deployment.yaml`):
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: your-deployment
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: your-app
     template:
       metadata:
         labels:
           app: your-app
       spec:
         containers:
         - name: your-container
           image: aksacr.azurecr.io/your-image-name
           ports:
           - containerPort: 80
   ```
   - Apply the deployment:
   ```sh
   kubectl apply -f deployment.yaml
   ```

7. **Configure API Management**:
   - Follow the Azure API Management documentation to configure your API and set up authentication.
   - Apply the API Management policy to enforce authentication and security:
     ```sh
     az apim api policy set --service-name aks-apim --api-id aks-api --policy-file apim-policy.xml
     ```

## Cleanup

To destroy the infrastructure created by Terraform, run:
```sh
terraform destroy
