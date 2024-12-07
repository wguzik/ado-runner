locals {
  # Common name prefix based on project and owner
  name_prefix = "${var.project_name}-${var.owner}"

  # Resource names
  resource_names = {
    resource_group = "${local.name_prefix}-rg"
    key_vault     = "${local.name_prefix}-kv"
    vnet          = "${local.name_prefix}-vnet"
    subnet        = "${local.name_prefix}-subnet"
    vm            = "${local.name_prefix}-vm"
  }

  admin_username = "adminuser"
}
