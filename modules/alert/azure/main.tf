#########
#### Creation of Alert for request count
#######

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

resource "azurerm_monitor_action_group" "action_grp" {
  name                = "${var.name}-actiongroup"
  resource_group_name = var.azure_resource_group
  short_name          = "short-name"
}

resource "azurerm_monitor_metric_alert" "requests_alert" {
  name                = var.name
  resource_group_name = var.azure_resource_group
  scopes              = [var.load_balancer_id]
  description         = "Action will be triggered when request count exceeds 10/min"
  enabled             = true
  window_size         = var.window_size
  severity            = var.severity

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "TotalRequests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_grp.id
  }
}

