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
