provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# Log-based Metric
resource "google_logging_metric" "log_metric" {
  name        = "log_based_metric"
  description = "Tracks error-level logs"
  filter      = "severity >= ERROR"

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

# Webhook Notification Channel
resource "google_monitoring_notification_channel" "webhook_channel" {
  display_name = "Webhook Notification Channel"
  type         = "webhook"

  labels = {
    url = var.webhook_url # Replace with your webhook URL
  }
}

# Email Notification Channel
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Notification Channel"
  type         = "email"

  labels = {
    email_address = var.notification_email # Replace with your email address
  }
}

# Alert Policy
resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Log-Based Metric Alert Policy"

  combiner = "OR"

  conditions {
    display_name = "Log Metric Condition"
    condition_threshold {
      filter = <<EOT
metric.type = "logging.googleapis.com/user/${google_logging_metric.log_metric.name}"
EOT
      comparison     = "COMPARISON_GT"
      threshold_value = 1
      duration        = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.webhook_channel.id,
    google_monitoring_notification_channel.email_channel.id
  ]
}
