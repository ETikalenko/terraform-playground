terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
}

module "enable_apis" {
  source = "terraform-google-modules/gcloud/google"

  platform                          = "linux"
  skip_download                     = false
  upgrade                           = false
  create_cmd_entrypoint             = "sh ${path.module}/scripts/gcloud.sh enable_apis"
  use_tf_google_credentials_env_var = true
}
