output "log_metric_name" {
  value = google_logging_metric.log_metric.name
}

output "email_notification_channel" {
  value = google_monitoring_notification_channel.email_channel.display_name
}

output "webhook_notification_channel" {
  value = google_monitoring_notification_channel.webhook_channel.display_name
}
