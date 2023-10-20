data "databricks_group" "catalog_admins" {
  display_name = var.catalog_admins_display_name
}

resource "databricks_grants" "catalog" {
  depends_on = [ databricks_catalog.catalog ]
  catalog    = databricks_catalog.catalog.name
  grant {
    principal  = data.databricks_group.catalog_admins.display_name
    privileges = var.catalog_privileges
  }
}