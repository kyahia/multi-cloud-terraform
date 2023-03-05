output "vm_private_ips" {
  value = azurerm_linux_virtual_machine.vms.*.private_ip_address
}
