# CREATE A PUBLIC IP FOR THE LOAD BALANCER
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# CREATE AN APPLICATION LOAD BALANCER
resource "azurerm_application_gateway" "alb" {
  name                = "app_lb"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 10
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.public_subnet_id
  }

  frontend_port {
    name = "fe-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-config"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

  backend_address_pool {
    name = "be-pool"
    ip_addresses = var.vms_private_ip
  }

  backend_http_settings {
    name                  = "be-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "lb-listener"
    frontend_ip_configuration_name = "fe-config"
    frontend_port_name             = "fe-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "route-rule"
    rule_type                  = "Basic"
    http_listener_name         = "lb-listener"
    backend_address_pool_name  = "be-pool"
    backend_http_settings_name = "be-settings"
  }
}