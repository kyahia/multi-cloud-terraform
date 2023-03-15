#########
#### Creation of the Load balancer
#######

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

locals {
  ports_map  = { for i in var.ports : index(var.ports, i) => i }
  vm_indexes = { for i in var.vms : index(var.vms, i) => index(var.vms, i) }
}

#########
#### Creation of the ip for the load balancer if scheme = external 
######### 
resource "azurerm_public_ip" "load_balancer_ip" {
  count               = var.scheme == "External" ? 1 : 0
  name                = "${var.name}-lb-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#########
#### CREATION OF THE APPLICATION LOAD BALANCER if type == Application
########
resource "azurerm_application_gateway" "application_load_balancer" {
  count               = var.type == "application" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.scheme != "External" ? "Standard_Medium" : "Standard_v2"
    tier     = var.scheme != "External" ?  "Standard" : "Standard_v2"
    # name     = "WAF_v2"
    # tier     = "WAF_v2"
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "${var.name}-ip-configuration"
    subnet_id = var.subnet
  }


  dynamic "frontend_port" {
    for_each = local.ports_map
    content {
      name = "${frontend_port.value}-frontend-port"
      port = frontend_port.value
    }
  }


  frontend_ip_configuration {
    name                          = "${var.name}-config"
    public_ip_address_id          = var.scheme == "External" ? azurerm_public_ip.load_balancer_ip[0].id : null
    subnet_id                     = var.scheme != "External" ? var.subnet : null
    private_ip_address_allocation = "Dynamic"
  }


  backend_address_pool {
    name         = "${var.name}-pool"
    ip_addresses = var.vms # list
  }

  dynamic "backend_http_settings" {
    for_each = local.ports_map
    content {
      name                  = "${backend_http_settings.value}-backend-settings"
      port                  = backend_http_settings.value
      cookie_based_affinity = "Disabled"
      protocol              = "Http"
      request_timeout       = 60
    }
  }


  dynamic "http_listener" {
    for_each = local.ports_map
    content {
      name                           = "${http_listener.value}-lb-listener"
      frontend_ip_configuration_name = "${var.name}-config"
      frontend_port_name             = "${http_listener.value}-frontend-port"
      protocol                       = "Http"
    }
  }


  dynamic "request_routing_rule" {
    for_each = local.ports_map
    content {
      name                       = "${request_routing_rule.value}-route-rule"
      rule_type                  = "Basic"
      http_listener_name         = "${request_routing_rule.value}-lb-listener"
      backend_address_pool_name  = "${var.name}-pool"
      backend_http_settings_name = "${request_routing_rule.value}-backend-settings"
      priority                   = var.scheme == "External" ? 1 : null
    }
  }

}


resource "azurerm_lb" "network_load_balancer" {
  count               = var.type == "network" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location


  frontend_ip_configuration {
    name                          = "${var.name}-front-config"
    subnet_id                     = var.scheme == "External" ? null : var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.scheme != "External" ? null : azurerm_public_ip.load_balancer_ip[0].id
  }

  sku = "Standard"
}

resource "azurerm_lb_backend_address_pool" "network_lb_backend" {
  count           = var.type == "network" ? 1 : 0
  loadbalancer_id = azurerm_lb.network_load_balancer[0].id
  name            = "${var.name}-BackEnd-Address-Pool"
}

resource "azurerm_lb_backend_address_pool_address" "pool_adress" {
  count                   = var.type == "network" ? length(var.vms) : 0
  name                    = "${var.name}-pool-adress-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.network_lb_backend[0].id
  ip_address              = var.vms[count.index]
  virtual_network_id      = var.virtual_network_id
}

# resource "azurerm_lb_outbound_rule" "outbount_rule" {
#   count                   = var.type == "network" && var.scheme == "External" ? 1 : 0
#   name                    = "${var.name}-Outbound-Rule"
#   loadbalancer_id         = azurerm_lb.network_load_balancer[0].id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.network_lb_backend[0].id

#   frontend_ip_configuration {
#     name = "${var.name}-front-config"
#   }
# }

resource "azurerm_lb_probe" "lb_probe" {
  for_each        = var.type == "network" ? local.ports_map : {}
  loadbalancer_id = azurerm_lb.network_load_balancer[0].id
  name            = "${each.value}-running-probe"
  port            = each.value
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each                       = var.type == "network" ? local.ports_map : {}
  loadbalancer_id                = azurerm_lb.network_load_balancer[0].id
  name                           = "${each.value}-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = each.value
  backend_port                   = each.value
  frontend_ip_configuration_name = "${var.name}-front-config"
  backend_address_pool_ids       = azurerm_lb_backend_address_pool.network_lb_backend.*.id
  probe_id                       = azurerm_lb_probe.lb_probe[each.key].id
}


