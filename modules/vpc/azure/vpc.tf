# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

#Creation du Vnet
resource "azurerm_virtual_network" "Vnet" {
  for_each            = var.vpc
  resource_group_name = each.value.azure_resource_group
  name                = each.value.vnet_name
  location            = each.value.location
  address_space       = [each.value.azure-cidr_vnet]
}

