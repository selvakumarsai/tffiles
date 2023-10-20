
data "databricks_group" "external_storage_admins" {
  display_name = var.external_storage_admins_display_name
}

resource "databricks_grants" "external_storage_credential" {
  storage_credential = databricks_storage_credential.external.id
  grant {
    principal  = var.external_storage_admins_display_name
    privileges = var.external_storage_privileges
  }
}

resource "databricks_grants" "external_storage" {
  external_location = databricks_external_location.some.id
  grant {
    principal  = var.external_storage_admins_display_name
    privileges = var.external_storage_privileges
  }
}