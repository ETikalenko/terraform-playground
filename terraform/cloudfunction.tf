resource "google_cloudfunctions_function" "mktoclean_function" {
  name        = "Mktoclean"
  description = "Delete expired marketo leads"
  runtime     = "go119"
  region      = var.cloud_function_region
  project     = var.project_id

  available_memory_mb          = 256
  source_archive_bucket        = "terraform-playground2022"
  source_archive_object        = "cloudfunctions/mktoclean/marketo.zip"
  entry_point                  = "MktocleanHandler"
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  ingress_settings             = "ALLOW_ALL"
  timeout                      = 300

  service_account_email = "marketo-sa@second-project-365923.iam.gserviceaccount.com"

  environment_variables = {
    MARKETO_DEBUG = var.marketo_debug
  }

  dynamic "secret_environment_variables" {
    for_each = var.cloudfunction_secrets
    content {
      key = secret_environment_variables.value
      secret = secret_environment_variables.value
      version = "latest"
    }
  }

}