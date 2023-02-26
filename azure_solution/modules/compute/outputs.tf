output "vm1_private_ip_address" {
  value = azurerm_linux_virtual_machine.vm1.private_ip_address
}

output "vm2_private_ip_address" {
  value = azurerm_linux_virtual_machine.vm2.private_ip_address
}