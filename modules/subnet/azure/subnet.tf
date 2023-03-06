resource "azurerm_subnet" "public_subnet" {
  for_each = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.vpc_name
  address_prefixes     = each.value.address_prefixes
}
