output "alb_id" {
  value = azurerm_application_gateway.alb.id
}

output "pip" {
  value = azurerm_public_ip.lb_pip
}