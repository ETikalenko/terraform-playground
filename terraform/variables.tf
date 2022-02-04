variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "location" {
  type        = string
  description = "Location"
  default     = "us-central"
}

variable "gmail_traffic_range" {
  type        = string
  description = "Gmail service traffic"
  default     = "0.1.0.20"
}
