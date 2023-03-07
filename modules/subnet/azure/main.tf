locals {
  private_subnet = { for k, v in var.subnet : k => v if startswith(v.type, "private") }
  public_subnet  = { for k, v in var.subnet : k => v if v.type == "public" }
}

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}


resource "azurerm_subnet" "public_subnets" {
  for_each             = local.public_subnet
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = [each.value.cidr_block]
}

resource "azurerm_subnet" "private_subnets" {
  for_each             = local.private_subnet
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = [each.value.cidr_block]
}
