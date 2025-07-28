resource "azurerm_resource_group" "rg" {
  name     = "eschool-rg"
  location = "East US"
}

module "network" {
  source           = "./modules/network"
  resource_group   = azurerm_resource_group.rg.name
  location         = azurerm_resource_group.rg.location
}

module "security_groups" {
  source         = "./modules/security_groups"
  vms            = var.vms
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
}

module "virtual_machines" {
  source             = "./modules/virtual_machines"
  vms                = var.vms 
  resource_group     = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  subnet_id          = module.network.subnet_id
  security_group_ids = module.security_groups.nsg_map
}
