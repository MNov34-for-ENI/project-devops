# Authentification via la session "az login".
# L'abonnement est lu dans la variable d'environnement ARM_SUBSCRIPTION_ID
# (ou celui actif dans la session az CLI).
provider "azurerm" {
  features {}
}
