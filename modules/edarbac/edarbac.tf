# Azure AD
provider "azuread" {
  version = ">=0.7.0"
}

provider "azurerm" {
  features {}
}


data "azurerm_subscription" "current" {}


# security group Data Admin
data "azuread_group" "sg_az_sub-uat_data_admin" {
  display_name = "AP-EDA-NP-DATA-ADMIN"
}

data "azurerm_storage_account" "eda-uat-dl"{
  name                = var.eda_uat_dl_name
  resource_group_name = var.eda_uat_rsg_name

}

data "azurerm_logic_app_standard" "eda-uat-logicapp" {
  name                = var.eda_uat_logicapp_name
  resource_group_name = var.eda_uat_rsg_name
}

data "azurerm_synapse_workspace" "eda-uat-synapse-wks" {
  name                = var.eda_uat_synapse_name
  resource_group_name = var.eda_uat_rsg_name
}

resource "azurerm_role_assignment" "uat_data_adm_dl_contributor" {
  scope                = data.azurerm_storage_account.eda-uat-dl.id
  role_definition_name = "Storage Blob Data contributor"
  principal_id       = data.azuread_group.sg_az_sub-uat_data_admin.id
}

resource "azurerm_role_assignment" "uat_logicapp_contributor" {
  scope                = data.azurerm_logic_app_standard.eda-uat-logicapp.id
  role_definition_name = "Logic App Contributor"
  principal_id       = data.azuread_group.sg_az_sub-uat_data_admin.id
}

resource "azurerm_synapse_role_assignment" "uat_synapse_admin" {
  synapse_workspace_id  = data.azurerm_synapse_workspace.eda-uat-synapse-wks.id
  role_name = "Synapse Administrator"
  principal_id       = data.azuread_group.sg_az_sub-uat_data_admin.id
}
