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

# cloudresourcemanager api cannot be enabled here by some reason, added to cloudbuild.yaml
variable "services" {
  type        = list(string)
  description = "List of APIs to enable"
  default     = [
    "iam.googleapis.com",
    "appengine.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

variable "credentials" {
  type        = string
  description = "Terraform service account credentials"
}
