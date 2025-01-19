variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "notification_email" {
  description = "Email for notifications"
  type        = string
}

variable "webhook_url" {
  description = "Webhook URL for notifications"
  type        = string
}
