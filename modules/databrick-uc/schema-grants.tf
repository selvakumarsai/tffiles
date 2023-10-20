
data "databricks_group" "schema_admins" {
  display_name = var.schema_admins_display_name
}

resource "databricks_grants" "schema" {
  depends_on = [ databricks_schema.schema ]
  schema = "${databricks_catalog.catalog.name}.${databricks_schema.schema.name}"
  grant {
    principal  = data.databricks_group.schema_admins.display_name
    privileges = var.schema_privileges
  }
}