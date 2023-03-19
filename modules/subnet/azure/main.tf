provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

locals {
  subnet_keys    = [for k, v in var.subnets : k]
  starting_index = length(flatten(var.previous_subnets))
}


resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [try(each.value.cidr_block, cidrsubnet("10.0.0.0/16", 8, index(local.subnet_keys, each.key) + local.starting_index))]
}

locals {
  private_subnet = { for k, v in var.subnets : k => azurerm_subnet.subnets[k] if v.type == "private" }
  public_subnet  = { for k, v in var.subnets : k => azurerm_subnet.subnets[k] if v.type == "public" }
}