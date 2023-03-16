provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_sns_topic" "notify_max_request" {
  name         = "notify-max-request"
  display_name = "notify max request"
}

resource "aws_cloudwatch_metric_alarm" "terr_http_request_alarm" {
  alarm_name          = "terra-http-request-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "10"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "SampleCount"

  dimensions = {
    #name = "AWS/ApplicationELB"
    LoadBalancerName = var.lb_name
  }
  actions_enabled = true
  alarm_actions = [aws_sns_topic.notify_max_request.arn]
}
