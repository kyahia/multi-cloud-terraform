# PRIVITIZE SERVERS SUBNET
resource "azurerm_network_security_group" "prv_nsg" {
  name                = "prv_nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnets["private_subnet"].id
  network_security_group_id = azurerm_network_security_group.prv_nsg.id
}

# OPEN INTERNET ACCESS
resource "azurerm_subnet_nat_gateway_association" "nat_subnet_association" {
  subnet_id      = azurerm_subnet.subnets["private_subnet"].id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}