#update 1
terraform {
   required_providers {
    #databricks = {
     # source = "databricks/databricks"
    #}  
    azapi = {
      source  = "azure/azapi"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.5.0"
    }

  }

 
  backend "azurerm" {
    resource_group_name  = "dbrick-iac"
    storage_account_name = "seldbrickiactfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azapi" {
}

provider "time" {
  version = "~> 0.4"
}

locals {
  module_path        = abspath(path.module)  
}


  #module "databrick-uc" {
  #  source = "./modules/databrick-uc" 
 #}

  module "customrole" {
    source = "./modules/customrole" 
 }

   module "edarbac" {
    source = "./modules/edarbac" 
 }
 