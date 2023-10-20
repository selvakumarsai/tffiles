

resource "databricks_schema" "schema" {
  depends_on   = [ databricks_catalog.catalog ]
  catalog_name = databricks_catalog.catalog.name
  name         = var.schema_name
}