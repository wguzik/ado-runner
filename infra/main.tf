module "resource_group" {
  source = "./modules/resource_group"
  
  resource_group_name = local.resource_names.resource_group
  location           = var.location
}

module "keyvault" {
  source = "./modules/keyvault"
  
  keyvault_name      = local.resource_names.key_vault
  location           = module.resource_group.location
  resource_group_name = module.resource_group.name
}

module "network" {
  source = "./modules/network"
  
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  vnet_name          = local.resource_names.vnet
  subnet_name        = local.resource_names.subnet
  address_space      = ["10.0.0.0/16"]
  subnet_prefix      = ["10.0.1.0/24"]
}

module "vm" {
  source = "./modules/vm"
  
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  vm_name            = local.resource_names.vm
  subnet_id          = module.network.subnet_id
  admin_username     = local.admin_username
  key_vault_id       = module.keyvault.key_vault_id
} 