variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "apim_name" {
  description = "The name of the API Management service"
  type        = string
}

variable "apim_publisher_name" {
  description = "The publisher name for API Management"
  type        = string
}

variable "apim_publisher_email" {
  description = "The publisher email for API Management"
  type        = string
}

variable "apim_sku_name" {
  description = "The SKU name for API Management"
  type        = string
  default     = "Developer_1"
}

variable "docker_image_name" {
  description = "The name of the Docker image to deploy"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "client_id" {
  description = "The Azure AD client ID"
  type        = string
}
