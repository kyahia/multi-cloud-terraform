locals {
  private_exists = length(local.private_subnets)
}

# PRIVITIZE SERVERS SUBNET
resource "azurerm_network_security_group" "prv_nsg" {
  count               = local.private_exists == 0 ? 0 : 1
  name                = "prv_nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = local.private_subnets
  subnet_id                 = local.private_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.prv_nsg[0].id
}
