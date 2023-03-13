provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

locals {
  subnet_keys    = [for k, v in var.subnets : k]
  starting_index = length(flatten(var.previous_subnets))

  subnets = var.cidr_mode == "manual" ? var.subnets : {
    for key in local.subnet_keys : key => {
      name       = var.subnets[key].name
      type       = var.subnets[key].type
      cidr_block = cidrsubnet("10.0.0.0/16", 8, index(local.subnet_keys, key) + local.starting_index)
    }
  }

  private_subnet = { for k, v in local.subnets : k => v if v.type == "private" }
  public_subnet  = { for k, v in local.subnets : k => v if v.type == "public" }
}


resource "azurerm_subnet" "public_subnets" {
  for_each             = local.public_subnet
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [each.value.cidr_block]

}



resource "azurerm_subnet" "private_subnets" {
  for_each             = local.private_subnet
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [each.value.cidr_block]
}
