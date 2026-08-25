# Infrastructure as Code — AKS (Terraform)

Provisionne un cluster AKS dans un resource group **existant** (fourni par l'école, non créé
par ce module). L'état Terraform reste **local** (`terraform.tfstate`, non versionné).

## Prérequis

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) connecté à votre compte :
  ```
  az login
  az account set --subscription <votre-subscription-id>
  ```

## Configuration

Chaque membre de l'équipe cible **son propre** resource group et l'identifie avec **son propre**
login (tag `user` obligatoire). Ces valeurs sont personnelles : copiez le modèle et renseignez
vos infos, ce fichier n'est pas versionné (`.gitignore`).

```
cp terraform.tfvars.example terraform.tfvars
```

Puis éditez `terraform.tfvars` :

```hcl
resource_group_name = "rg-<votre-login>_cours-projet"
myuid                = "<votre-login>"
```

En cas d'erreur de taille du nœud (ex : Standard_B2s au lieu de Standard_B2ms), il faut éditer le `main.tf` :

dans > `default_node_pool` {
```
    temporary_name_for_rotation = "tempdefault"
```
Puis `terraform destroy` / `terraform plan` / `terraform apply`

Pour détruire, repréparer, et recréer le cluster avec le bon format.

## Utilisation

```
terraform init
terraform plan
terraform apply
```

Une fois le cluster créé, récupérez les credentials `kubectl` (la commande exacte est aussi
disponible via `terraform output get_credentials_command`) :

```
az aks get-credentials --resource-group <resource_group_name> --name <cluster_name>
```

## Ce que ça crée

- Un cluster AKS (`azurerm_kubernetes_cluster`) dans le resource group existant, avec :
  - Un node pool unique `system` (taille et nombre de nœuds configurables via `vm_size` /
    `node_count`)
  - Identité managée `SystemAssigned` (pas de secret à gérer)
  - `network_policy = "azure"` activé dès la création (sinon les NetworkPolicy Kubernetes
    seraient acceptées mais sans effet)
  - Les tags du resource group hérités automatiquement + le tag `user = <myuid>` requis par
    les consignes du projet

## Nettoyage

```
terraform destroy
```
## Commandes extraites de live runs : 
```
╰─❯❯❯ terraform plan   
data.azurerm_resource_group.this: Reading...
data.azurerm_resource_group.this: Read complete after 0s [id=/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-CBedel2025_cours-projet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.this will be created
  + resource "azurerm_kubernetes_cluster" "this" {
      + ai_toolchain_operator_enabled       = false
      + current_kubernetes_version          = (known after apply)
      + dns_prefix                          = "project-devops"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "francecentral"
      + name                                = "project-devops"
      + node_os_upgrade_channel             = "NodeImage"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_enabled                 = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + resource_group_name                 = "rg-CBedel2025_cours-projet"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + support_plan                        = "KubernetesOfficial"
      + tags                                = {
          + "BypassPermAllRestrict" = "false"
          + "BypassTempAllRestrict" = "false"
          + "aksnumber"             = "1"
          + "cours"                 = "cours-projet"
          + "promotion"             = "HASDO_002"
          + "user"                  = "CBedel2025"
        }
      + workload_identity_enabled           = false

      + auto_scaler_profile (known after apply)

      + bootstrap_profile (known after apply)

      + default_node_pool {
          + kubelet_disk_type           = (known after apply)
          + max_pods                    = (known after apply)
          + name                        = "default"
          + node_count                  = 2
          + node_labels                 = (known after apply)
          + orchestrator_version        = (known after apply)
          + os_disk_size_gb             = (known after apply)
          + os_disk_type                = "Managed"
          + os_sku                      = (known after apply)
          + scale_down_mode             = "Delete"
          + temporary_name_for_rotation = "tempdefault"
          + type                        = "VirtualMachineScaleSets"
          + ultra_ssd_enabled           = false
          + vm_size                     = "Standard_B2ms"
          + workload_runtime            = (known after apply)

          + upgrade_settings {
              + max_surge = "10%"
            }
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + kubelet_identity (known after apply)

      + network_profile {
          + dns_service_ip     = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_data_plane = "azure"
          + network_mode       = (known after apply)
          + network_plugin     = "azure"
          + network_policy     = "azure"
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile (known after apply)

          + nat_gateway_profile (known after apply)
        }

      + node_provisioning_profile (known after apply)

      + windows_profile (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_name            = "project-devops"
  + get_credentials_command = "az aks get-credentials --resource-group rg-CBedel2025_cours-projet --name project-devops"
  + resource_group_name     = "rg-CBedel2025_cours-projet"
  ```

  Et l'apply : 
  ```
❯❯❯ terraform apply
data.azurerm_resource_group.this: Reading...
data.azurerm_resource_group.this: Read complete after 0s [id=/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-CBedel2025_cours-projet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.this will be created
  + resource "azurerm_kubernetes_cluster" "this" {
      + ai_toolchain_operator_enabled       = false
      + current_kubernetes_version          = (known after apply)
      + dns_prefix                          = "project-devops"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "francecentral"
      + name                                = "project-devops"
      + node_os_upgrade_channel             = "NodeImage"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_enabled                 = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + resource_group_name                 = "rg-CBedel2025_cours-projet"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + support_plan                        = "KubernetesOfficial"
      + tags                                = {
          + "BypassPermAllRestrict" = "false"
          + "BypassTempAllRestrict" = "false"
          + "aksnumber"             = "0"
          + "cours"                 = "cours-projet"
          + "promotion"             = "HASDO_002"
          + "user"                  = "CBedel2025"
        }
      + workload_identity_enabled           = false

      + auto_scaler_profile (known after apply)

      + bootstrap_profile (known after apply)

      + default_node_pool {
          + kubelet_disk_type           = (known after apply)
          + max_pods                    = (known after apply)
          + name                        = "default"
          + node_count                  = 2
          + node_labels                 = (known after apply)
          + orchestrator_version        = (known after apply)
          + os_disk_size_gb             = (known after apply)
          + os_disk_type                = "Managed"
          + os_sku                      = (known after apply)
          + scale_down_mode             = "Delete"
          + temporary_name_for_rotation = "tempdefault"
          + type                        = "VirtualMachineScaleSets"
          + ultra_ssd_enabled           = false
          + vm_size                     = "Standard_B2ms"
          + workload_runtime            = (known after apply)

          + upgrade_settings {
              + max_surge = "10%"
            }
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + kubelet_identity (known after apply)

      + network_profile {
          + dns_service_ip     = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_data_plane = "azure"
          + network_mode       = (known after apply)
          + network_plugin     = "azure"
          + network_policy     = "azure"
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile (known after apply)

          + nat_gateway_profile (known after apply)
        }

      + node_provisioning_profile (known after apply)

      + windows_profile (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cluster_name            = "project-devops"
  + get_credentials_command = "az aks get-credentials --resource-group rg-CBedel2025_cours-projet --name project-devops"
  + resource_group_name     = "rg-CBedel2025_cours-projet"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_kubernetes_cluster.this: Creating...
azurerm_kubernetes_cluster.this: Still creating... [00m10s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [00m20s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [00m30s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [00m40s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [00m50s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [01m00s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [01m10s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [01m20s elapsed]
azurerm_kubernetes_cluster.this: Still creating... [01m30s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [01m40s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [01m50s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m00s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m10s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m20s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m30s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m40s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [02m50s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m00s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m10s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m20s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m30s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m40s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [03m50s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m00s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m10s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m20s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m30s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m40s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Still creating... [04m50s elapsed]                                                                    
azurerm_kubernetes_cluster.this: Creation complete after 4m51s [id=/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-CBedel2025_cours-projet/providers/Microsoft.ContainerService/managedClusters/project-devops]                                         
                                                                                                                                       
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.                                                                            
                                                                                                                                       
Outputs:                                                                                                                               
                                                                                                                                       
cluster_name = "project-devops"                                                                                                        
get_credentials_command = "az aks get-credentials --resource-group rg-CBedel2025_cours-projet --name project-devops"                   
resource_group_name = "rg-CBedel2025_cours-projet"
  ```