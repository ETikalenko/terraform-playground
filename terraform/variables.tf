variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
  default     = "second-project-365923"
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

variable "state_bucket" {
  type        = string
  description = "Bucket where state file is stored"
  default     = "terraform-playground2022"
}

variable "cloud_function_region" {
  type        = string
  description = "Region where cloud functions are located"
  default     = "us-east1"
}

variable "marketo_debug" {
  type        = bool
  description = "Enable marketo debug"
  default     = true
}

variable "cloudfunction_secrets" {
  type        = list(string)
  description = "marketo secrets"
  default = [
    "marketo_id",
    "marketo_secret",
    "marketo_munchkin_id"
  ]
}
