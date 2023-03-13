#in this file we create a nat to associate with private subnets

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}


#Creation of Nat gateway
resource "azurerm_nat_gateway" "nat" {
  count = var.nat_id == "" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "Standard"
}

#Creation of ip to nat gateway
resource "azurerm_public_ip" "nat_ip" {
  count = var.nat_id == "" ? 1 : 0
  name                = "ip-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Association of  ip with Nat gateway
resource "azurerm_nat_gateway_public_ip_association" "ip_assos_nat" {
  count = var.nat_id == "" ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat[0].id
  public_ip_address_id = azurerm_public_ip.nat_ip[0].id
}


#Associate the Private Subnets <==> nat gateway
resource "azurerm_subnet_nat_gateway_association" "subnet_assos_nat" {
  for_each       = var.subnets
  subnet_id      = each.value
  nat_gateway_id = var.nat_id == "" ? try(azurerm_nat_gateway.nat[0].id, "") : var.nat_id
}

