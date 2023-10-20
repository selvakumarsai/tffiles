

resource "databricks_metastore" "metastore" {
  name          = var.metastore_name
  storage_root  = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.unity_catalog.name,
    azurerm_storage_account.unity_catalog.name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "metastore_data_access" {
  depends_on   = [ databricks_metastore.metastore ]
  metastore_id = databricks_metastore.metastore.id
  name         = var.metastore_label
  azure_managed_identity {
    access_connector_id = azapi_resource.access_connector.id
  }
  is_default   = true
}

resource "databricks_metastore_assignment" "default_metastore" {
  depends_on           = [ databricks_metastore_data_access.metastore_data_access ]
  workspace_id         = var.default_metastore_workspace_id
  metastore_id         = databricks_metastore.metastore.id
  default_catalog_name = var.default_metastore_default_catalog_name
}