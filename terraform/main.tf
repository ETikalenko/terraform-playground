terraform {
  required_version = ">= 0.12.24"
  required_providers {
    google = ">= 3.18.0"
  }

  backend "gcs" {
    bucket = "terraform-lab-bucket"
    prefix = "terraform/state"
  }
}

data "google_secret_manager_secret_version" "tf_sa_credentials" {
  project = var.project_id
  secret = "terraform_sa_credentials"
}

provider "google" {
  project     = var.project_id
  credentials = "${file(var.credentials)}"
}

module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.1.0"

  platform = "linux"

  create_cmd_entrypoint  = "${path.module}/scripts/enable_apis.sh"
  create_cmd_body = ""
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body = ""

  skip_download = true
  upgrade = false
}

//resource "google_project_service" "enable_apis" {
//  project = var.project_id
//  for_each = toset(var.services)
//  service = each.value
//
//  disable_dependent_services = true
//  disable_on_destroy = false
//}

// This is used to check if appengine is already created. If run it second time terraform script will fail with an error
data "google_app_engine_default_service_account" "default" {
  depends_on = [
    module.gcloud,
  ]
}

resource "google_app_engine_application" "inbound-mail-app" {
  project = var.project_id
  location_id = var.location

  depends_on = [
    module.gcloud,
  ]
}

//resource "google_app_engine_standard_app_version" "myapp_v2" {
//  service = ""
//  runtime = "python38"
//  deployment {}
//}

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
