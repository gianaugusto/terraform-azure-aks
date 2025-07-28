output "apim_url" {
  description = "The URL of the API Management instance"
  value       = azurerm_api_management.apim.public_ip_addresses[0]
}

output "aks_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}
