locals {
  subnets = {
    public_subnet = {
      name       = "public",
      cidr_block = "10.0.1.0/24"
    },
    private_subnet = {
      name       = "private",
      cidr_block = "10.0.2.0/24"
    }
  }
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.VPC.name
  address_prefixes     = [each.value.cidr_block]
}


