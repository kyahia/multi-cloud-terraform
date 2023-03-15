output "load_balancer" {
  value = var.type == "application" ? azurerm_application_gateway.application_load_balancer[0] : azurerm_lb.network_load_balancer[0]
}

