# Le resource group est LU (data), il n'est PAS créé ici.
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = var.cluster_name
  sku_tier            = "Free" # control plane managé, non facturé (sans SLA)

  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.vm_size
    # Reprend la valeur par défaut d'AKS : sans ce bloc, azurerm 4.x voudrait
    # le SUPPRIMER à un plan ultérieur -> diff parasite sur le cluster.
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned" # identité managée : aucun secret à gérer
  }

  # Réseau : moteur de NetworkPolicy activé dès la création (sinon les
  # NetworkPolicy sont acceptées mais SANS EFFET).
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  # Le cluster hérite des étiquettes du resource group (conformité policy école),
  # puis ajoute le tag "user" obligatoire pour ce projet.
  tags = merge(data.azurerm_resource_group.this.tags, { user = var.myuid })

  # Certaines étiquettes sont (re)mutées par l'Azure Policy de l'école après création :
  # on ignore leurs dérives pour garder des plans STABLES.
  lifecycle {
    ignore_changes = [tags]
  }
}
