resource "azurerm_monitor_action_group" "action_grp" {
  name                = "my-actiongroup"
  resource_group_name = var.resource_group_name
  short_name          = "myactgrp"
}

resource "azurerm_monitor_metric_alert" "requests_alert" {
  name                = "metricalert"
  resource_group_name = var.resource_group_name
  scopes              = [var.load_balancer_id]
  description         = "Action will be triggered when request count exceeds 10/min"
  enabled             = true
  window_size         = "PT1M"
  severity            = 0

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "TotalRequests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_grp.id
  }
}
