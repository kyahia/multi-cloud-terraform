# PRIVITIZE SERVERS SUBNET
resource "azurerm_network_security_group" "prv_nsg" {
  count               = length(local.private_subnets) > 0 && var.security_group_id == "" ? 1 : 0
  name                = "prv_nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = local.private_subnets
  subnet_id                 = local.private_subnets[each.key].id
  network_security_group_id = var.security_group_id == "" ? azurerm_network_security_group.prv_nsg[0].id : var.security_group_id
}
