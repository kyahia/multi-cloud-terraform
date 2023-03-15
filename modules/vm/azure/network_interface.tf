######
# CREATE NETWORK INTERFACES With ip adress if is it required by the user needs (public vms)
######

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

####
# Select public vms from all the vms to create public ip to them
####
locals {
  public_vms = {
    for k, v in var.vms : k => v if v.pub_ip == true
  }
}



#Creation of the ip adress if it's required (user needs)
resource "azurerm_public_ip" "vm_ip" {
  for_each            = local.public_vms
  name                = "${each.value.name}-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


# Creation of the network inteface  
resource "azurerm_network_interface" "ni" {
  for_each            = var.vms
  name                = "${each.value.name}-ni"
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    subnet_id                     = each.value.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = each.value.pub_ip == true ? azurerm_public_ip.vm_ip[each.key].id : ""
  }
}


