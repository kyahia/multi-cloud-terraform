# CREATE A SECURITY GROUP
resource "azurerm_network_security_group" "sg" {
  for_each            = var.vms
  name                = "${each.value.name}-sg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "${each.value.name}-security_rule"
    priority                   = var.rule_priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = each.value.openports
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Associate security groupe to the network interface
resource "azurerm_network_interface_security_group_association" "ni_sg_association" {
  for_each                  = var.vms
  network_interface_id      = azurerm_network_interface.ni[each.key].id
  network_security_group_id = azurerm_network_security_group.sg[each.key].id
}
