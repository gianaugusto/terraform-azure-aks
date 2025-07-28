provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.application_name}-aks"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${var.application_name}-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management" "apim" {
  name                = "${var.application_name}-apim"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  publisher_name      = "Giancarlos Augusto Macedo"
  publisher_email     = "gianaugusto@gmail.com"
  sku_name            = "Developer_1"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_api" "ding_api" {
  name                = "ding-api"
  resource_group_name = azurerm_resource_group.aks_rg.name
  api_management_name = azurerm_api_management.apim.name
  path                = "sample"
  protocols           = ["https"]
  service_url         = "https://ding-scheduler.com"
  import {
    content_format = "swagger-link"
    content_value  = "https://ding-scheduler.com/v1/swagger.json"
  }
}

resource "azurerm_api_management_api_operation" "ping_operation" {
  operation_id   = "ping-operation"
  api_name       = azurerm_api_management_api.sample_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.aks_rg.name
  display_name   = "Ping Operation"
  method         = "GET"
  url_template   = "/ping"
  description    = "Ping API Operation"
}

resource "azurerm_api_management_api_policy" "sample_policy" {
  api_name       = azurerm_api_management_api.ding_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.aks_rg.name
  xml_content    = file("${path.module}/apim-policy.xml")
}
