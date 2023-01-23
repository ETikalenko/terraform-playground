resource "google_secret_manager_secret" "xseries_cloudfunction_secrets" {
  for_each  = toset(var.cloudfunction_secrets)
  project   = var.project_id
  secret_id = each.key
  replication {
    automatic = true
  }
}