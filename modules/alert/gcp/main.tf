provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}


resource "google_monitoring_notification_channel" "email" {
  display_name = var.notification.name
  type = var.notification.type
  labels = {
    email_address = var.notification.email
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = var.name
  combiner = var.combiner

  conditions {
    display_name = var.condition.name

    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" " # stay static for moment b/c we have only one type
      duration = "${tostring(var.condition.duration)}s"
      comparison = var.condition.comparaison == ">" ? "COMPARISON_GT" : "COMPARISON_LT"
      threshold_value = "10"

        aggregations {
            alignment_period = "${tostring(var.condition.alignment_period)}s"
            per_series_aligner = var.condition.per_series_aligner
      }
    }
  }

  notification_channels = [
      "${google_monitoring_notification_channel.email.id}",
  ]
}