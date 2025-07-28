terraform {
  backend "azurerm" {
    resource_group_name  = "rg-myapp"
    storage_account_name = "mystatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
