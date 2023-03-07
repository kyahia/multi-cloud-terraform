#in this file we create a nat to associate with private subnets

locals {
  private_subnet_nat = { for k, v in var.subnet : k => v if v.type == "private with nat" }
}

#Creation of ip to nat gateway
resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creation of Nat gateway
resource "azurerm_nat_gateway" "nat" {
  name                = "auto-nat"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "Standard"
}

#Association of  ip with Nat gateway
resource "azurerm_nat_gateway_public_ip_association" "ip_assos_nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}


#Associate ze Private Subnets <==> nat gateway
resource "azurerm_subnet_nat_gateway_association" "subnet_assos_nat" {
  for_each       = local.private_subnet_nat
  subnet_id      = azurerm_subnet.private_subnets[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

