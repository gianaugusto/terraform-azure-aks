# Terraform Azure AKS + APIM Setup

This repository contains Terraform configurations to provision an Azure Kubernetes Service (AKS) cluster and deploy Azure API Management (APIM) with a sample API protected using OAuth 2.0 / Azure AD authentication.

## Prerequisites

- Terraform CLI ≥ 1.4: [Download](https://developer.hashicorp.com/terraform/downloads)
- Azure CLI: [Install](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Logged in with `az login`
- Contributor access to the target Azure subscription
- Ability to register apps in Azure AD (for OAuth)

## Local Authentication

Use Azure CLI login:

```bash
az login
az account set --subscription <your-subscription-id>
```

## GitHub Actions Authentication

Create a Terraform Service Principal:

```bash
az ad sp create-for-rbac \
  --name terraform-sp \
  --role Contributor \
  --scopes /subscriptions/<your-subscription-id> \
  --sdk-auth
```

Store the full JSON output in GitHub Secrets:

- `ARM_CLIENT_ID`: From clientId
- `ARM_CLIENT_SECRET`: From clientSecret
- `ARM_SUBSCRIPTION_ID`: From subscriptionId
- `ARM_TENANT_ID`: From tenantId
- `ARM_CREDENTIALS`: Full JSON output (optional alternative)

## Usage

### Local Deployment

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Plan the deployment:

   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```

3. Apply the deployment:

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

### Destroying Resources

To destroy the resources, run:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## GitHub Actions CI/CD Pipeline

The GitHub Actions workflow is defined in `.github/workflows/terraform.yml`. It runs on every push to the `main` branch and on pull requests. The workflow uses the secrets stored in GitHub to authenticate with Azure.

## Security

- Do not commit `terraform.tfvars` or secrets to GitHub.
- Use GitHub Secrets to store all credentials.
- Validate with `terraform validate` and format with `terraform fmt`.
