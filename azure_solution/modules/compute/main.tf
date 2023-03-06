# CREATE NETWORK INTERFACES
resource "azurerm_network_interface" "nic" {
  count                = var.servers_count
  name                 = "nic-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# CREATE VMs
resource "azurerm_linux_virtual_machine" "vms" {
  count               = var.servers_count
  name                = "vm-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false

  custom_data = filebase64("./script.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

}

# CREATE A SECURITY GROUP
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic1_nsg_association" {
  count                     = var.servers_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
