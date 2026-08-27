output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "get_credentials_command" {
  value = "az aks get-credentials --resource-group ${data.azurerm_resource_group.this.name} --name ${azurerm_kubernetes_cluster.this.name}"
}

# Les 5 valeurs à coller dans les secrets GitHub Actions (Settings > Environments > <env Prénom>).
output "AKS_RG" {
  value = data.azurerm_resource_group.this.name
}

output "AKS_CLUSTER" {
  value = azurerm_kubernetes_cluster.this.name
}

output "AZURE_CLIENT_ID" {
  value = azurerm_user_assigned_identity.ci.client_id
}

output "AZURE_TENANT_ID" {
  value = azurerm_user_assigned_identity.ci.tenant_id
}

output "AZURE_SUBSCRIPTION_ID" {
  value = data.azurerm_client_config.current.subscription_id
}
