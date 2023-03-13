locals {
  private_exists = length(azurerm_subnet.private_subnets)
}

# PRIVITIZE SERVERS SUBNET
resource "azurerm_network_security_group" "prv_nsg" {
  count = local.private_exists == 0 ? 0 : 1
  name                = "prv_nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = { for k, v in var.subnets : k => v if v.type == "private" }
  subnet_id                 = azurerm_subnet.private_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.prv_nsg[0].id
}