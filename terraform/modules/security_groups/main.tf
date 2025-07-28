locals {
  nsg_map = {
    for vm in var.vms : vm.name => azurerm_network_security_group.nsgs[vm.name].id
  }
}

resource "azurerm_network_security_group" "nsgs" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group

  dynamic "security_rule" {
    for_each = each.value.ports
    content {
      name                       = "allow_${security_rule.value}"
      priority                   = 100 + index(each.value.ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "${security_rule.value}"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
