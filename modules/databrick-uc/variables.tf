##################################################
# VARIABLES                                      #
##################################################

variable "databricks_resource_id" {
  description = "The Azure resource ID for the Azure Databricks workspace."
  default = "/subscriptions/369c6a47-2323-409e-8284-e40ed50570c7/resourceGroups/demodb-rg/providers/Microsoft.Databricks/workspaces/demodb-workspace"
}

variable "metastore_name" {
default="selpoc_metastore"
}
variable "metastore_label" {
  default ="metastore"
}
variable "default_metastore_workspace_id" {
  default = "746194851286118"
}
variable "default_metastore_default_catalog_name" {
  default = "selpoc_catalog"
}
variable "catalog_name" {
  default = "selpoc_adm"
}

variable "catalog_admins_display_name" {
  default = "account users"
}
variable "catalog_privileges" {
  default = [ "ALL_PRIVILEGES" ]
}

variable "schema_name" {
  default = "selpoc_schema"
}
variable "schema_admins_display_name" {
  default = "account users"
}
variable "schema_privileges" {
  default =[ "ALL_PRIVILEGES" ]
}

variable "external_storage_admins_display_name" {
default = "account users"
}
variable "external_storage_privileges" {
default =[ "ALL_PRIVILEGES" ]
}