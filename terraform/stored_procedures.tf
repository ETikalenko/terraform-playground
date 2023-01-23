data "template_file" "sproc_base64_to_vend" {
  template = "${file("./bq_sql_scripts/base64_to_vend.sql")}"
  vars = {
    project_id = "second-project-365923"
    dataset = "test"
  }
}

resource "google_bigquery_routine" "sproc_create_base64_to_vend" {
  dataset_id      = "test"
  routine_id      = "base64_to_vend"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sproc_base64_to_vend.rendered}"
}
