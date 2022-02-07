terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    prefix = "terraform/state"
  }
}

provider "google" {
  project     = var.project_id
}

module "enable_apis" {
  source  = "terraform-google-modules/gcloud/google"

  platform = "linux"
  skip_download = false
  upgrade = false
  create_cmd_entrypoint  = "sh ${path.module}/scripts/gcloud.sh enable_apis"
  use_tf_google_credentials_env_var = true
}

resource "google_app_engine_application" "inbound-mail-app" {
  project = var.project_id
  location_id = var.location

  depends_on = [
    module.enable_apis,
  ]
}

module "deploy_appengine" {
  source  = "terraform-google-modules/gcloud/google"

  platform = "linux"
  skip_download = false
  upgrade = false
  create_cmd_entrypoint  = "sh ${path.module}/scripts/gcloud.sh deploy_app"
  destroy_cmd_entrypoint = "gcloud"
  use_tf_google_credentials_env_var = true
  module_depends_on = [module.enable_apis]
}

resource "google_app_engine_firewall_rule" "gmail_traffic" {
  description  = "Only mail traffic is allowed"
  project      = var.project_id
  priority     = 1
  action       = "ALLOW"
  source_range = var.gmail_traffic_range

  depends_on = [
    google_app_engine_application.inbound-mail-app
  ]
}

resource "google_app_engine_firewall_rule" "default_rule" {
  description  = "Deny all traffic except gmail service"
  project      = var.project_id
  priority     = 2
  action       = "DENY"
  source_range = "*"

  depends_on = [
    google_app_engine_application.inbound-mail-app
  ]
}
