provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name
}

resource "azurerm_api_management_api" "api" {
  name                = "aks-api"
  resource_group_name = azurerm_resource_group.aks_rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "AKS API"
  path                = "aks"
  protocols           = ["https"]
  service_url         = "https://${azurerm_kubernetes_cluster.aks.fqdn}"
}

resource "azurerm_api_management_api_operation" "operation" {
  operation_id        = "get"
  api_name             = azurerm_api_management_api.api.name
  api_management_name  = azurerm_api_management.apim.name
  resource_group_name  = azurerm_resource_group.aks_rg.name
  display_name         = "Get AKS"
  method               = "GET"
  url_template         = "/aks"
  response {
    status_code = 200
    description = "Successful response"
  }
}
