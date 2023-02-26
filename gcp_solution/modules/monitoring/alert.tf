resource "google_monitoring_alert_policy" "http_request_alert" {
  display_name = "HTTP Request Alert"

  combiner = "OR"

  conditions {

    display_name = "HTTP Request Condition"
    condition_threshold {
      filter = "resource.type = \"https_lb_rule\" AND resource.labels.forwarding_rule_name = \"${var.lb_name}\" AND metric.type = \"loadbalancing.googleapis.com/https/backend_request_count\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 100
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
      trigger {
        count = 1
      }
    }
  }
}
