output "vm" {
  value = { 
    for k, v in var.vms : 
      k => merge(
        azurerm_network_interface.ni[k], 
        azurerm_virtual_machine.vms[k]
        ) 
    }
  sensitive = true
  }