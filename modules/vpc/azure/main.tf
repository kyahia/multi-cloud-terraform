# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

#Creation du Vnet
resource "azurerm_virtual_network" "Vnet" {
  for_each            = var.vpcs
  resource_group_name = var.azure_resource_group
  name                = each.value.name
  location            = each.value.location
  address_space       = var.cidr_mode == "auto" ? ["10.0.0.0/16"] : [try(each.value.cidr_block, "10.0.0.0/16")]
}



