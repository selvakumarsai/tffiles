##################################################
# VARIABLES                                      #
##################################################
#Custom RBAC Roles
variable "deploy_custom_roles" {
  type        = bool
  default     = true
  description = "Specifies whether custom RBAC roles should be created"
}
variable "custom_role_definitions" {
  type        = list(any)
  description = "Required Input - Specifies a list of AZURE Custom Role Definitions of type ANY"
  default = [
  {
    role_definition_name = "CUSTOM - RG Reader"
    description          = "RG Read"
    permissions = {
      actions          = ["*/read","Microsoft.Resources/subscriptions/resourceGroups/write"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  },
  {
    role_definition_name = "CUSTOM - RG Write"
    description          = "RG Write"
    permissions = {
      actions          = ["*/read","Microsoft.Resources/subscriptions/resourceGroups/write"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  }
]
}