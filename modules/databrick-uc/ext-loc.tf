resource "azurerm_databricks_access_connector" "ext_access_connector" {
  name                = "ext1-databricks-mi"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "ext_storage" {
  name                     = "${local.prefix}extstorageselva"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  tags                     = data.azurerm_resource_group.this.tags
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "ext_storage_bronze" {
  name                  = "${local.prefix}-ext-bronze"
  storage_account_name  = azurerm_storage_account.ext_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "ext_storage_silver" {
  name                  = "${local.prefix}-ext-silver"
  storage_account_name  = azurerm_storage_account.ext_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "ext_storage_gold" {
  name                  = "${local.prefix}-ext-gold"
  storage_account_name  = azurerm_storage_account.ext_storage.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "ext_storage" {
  scope                = azurerm_storage_account.ext_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.ext_access_connector.identity[0].principal_id
}


resource "databricks_storage_credential" "external" {
  name = azurerm_databricks_access_connector.ext_access_connector.name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.ext_access_connector.id
  }
  comment = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.default_metastore
  ]
}

resource "databricks_grants" "external_creds" {
  storage_credential = databricks_storage_credential.external.id
  grant {
    principal  = "account users"
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_external_location" "some" {
  name = "external"
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.ext_storage_bronze.name,
  azurerm_storage_account.ext_storage.name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.default_metastore
  ]
}

resource "databricks_external_location" "some-silver" {
  name = "external-silver"
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.ext_storage_silver.name,
  azurerm_storage_account.ext_storage.name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.default_metastore
  ]
}

resource "databricks_external_location" "some-gold" {
  name = "external-gold"
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.ext_storage_gold.name,
  azurerm_storage_account.ext_storage.name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.default_metastore
  ]
}

resource "databricks_grants" "some" {
  external_location = databricks_external_location.some.id
  grant {
    principal  = "account users"
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_grants" "some-silver" {
  external_location = databricks_external_location.some-silver.id
  grant {
    principal  = "account users"
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_grants" "some-gold" {
  external_location = databricks_external_location.some-gold.id
  grant {
    principal  = "account users"
    privileges = ["ALL_PRIVILEGES"]
  }
}