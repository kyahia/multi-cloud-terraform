locals {
  os    = jsondecode(file("./modules/vm/azure/os.json"))
  specs = jsondecode(file("./modules/vm/azure/spec.json"))
}


# CREATE VMs
resource "azurerm_virtual_machine" "vms" {
  for_each            = var.vms
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  vm_size = each.value.configuration == "manual" ? local.specs["${each.value.cores}_${each.value.ram}_${each.value.arch}"] : "Standard_D2s_v3"


  network_interface_ids = [
    azurerm_network_interface.ni[each.key].id
  ]

  os_profile {
    computer_name  = each.value.name
    admin_username = try(each.value.username, "admin")
    admin_password = try(each.value.password, "")
    custom_data    = try(each.value.custom_data, "")

  }


  dynamic "os_profile_linux_config" {
    for_each = each.value.os == "Windows" ? {} : { a = 1 }
    content {
      disable_password_authentication = false

      dynamic "ssh_keys" {
        for_each = try(each.value.ssh_key," ") == " " ? {} : { a = 1 }
        content {
          key_data = each.value.ssh_key
          path     = "/home/${each.value.username}/.ssh/authorized_keys"
        }

      }
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = each.value.os != "Windows" ? {} : { a = 1 }
    content {
    }
  }

  storage_os_disk {
    name              = "${each.value.name}-disk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }



  storage_image_reference {
    publisher = each.value.configuration == "manual" ? local.os["${each.value.os}_${each.value.version}_${each.value.arch}"].publisher : "Canonical"
    offer     = each.value.configuration == "manual" ? local.os["${each.value.os}_${each.value.version}_${each.value.arch}"].offer : "0001-com-ubuntu-minimal-jammy"
    sku       = each.value.configuration == "manual" ? local.os["${each.value.os}_${each.value.version}_${each.value.arch}"].sku : "minimal-22_04-lts-gen2"
    version   = each.value.configuration == "manual" ? local.os["${each.value.os}_${each.value.version}_${each.value.arch}"].version : "latest"
  }

}
