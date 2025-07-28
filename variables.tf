variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "api_client_id" {
  description = "The client ID for the API"
  type        = string
}
