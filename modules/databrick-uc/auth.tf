locals {
  resource_regex            = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Databricks/workspaces/(.+)"
  subscription_id           = regex(local.resource_regex, var.databricks_resource_id)[0]
  resource_group            = regex(local.resource_regex, var.databricks_resource_id)[1]
  databricks_workspace_name = regex(local.resource_regex, var.databricks_resource_id)[2]
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  databricks_workspace_host = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id   = data.azurerm_databricks_workspace.this.workspace_id
  prefix                    = replace(replace(lower(data.azurerm_resource_group.this.name), "rg", ""), "-", "")
}

data "azurerm_resource_group" "this" {
  name = local.resource_group
}

data "azurerm_client_config" "current" {
}

data "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = local.resource_group
}

terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azapi" {
  subscription_id = local.subscription_id
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.this.id
  host = local.databricks_workspace_host
}
