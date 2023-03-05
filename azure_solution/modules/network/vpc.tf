# CREATE A VPC WITH SUBNETS
resource "azurerm_virtual_network" "VPC" {
  name                = "VPC"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

# CREATE A NAT WITH PIP
resource "azurerm_public_ip" "nat_pip" {
  name                = "auto-nat-publicIP"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat" {
  name                = "auto-nat"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_eip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}