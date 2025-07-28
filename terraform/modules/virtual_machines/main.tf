resource "azurerm_public_ip" "pip" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"   
  sku                 = "Standard" 
}

resource "azurerm_network_interface" "nic" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "assoc" {
  for_each = { for vm in var.vms : vm.name => vm }
  network_interface_id      = azurerm_network_interface.nic[each.value.name].id
  network_security_group_id = var.security_group_ids[each.value.name]
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = each.key
  resource_group_name = var.resource_group
  location            = var.location
  size                = each.value.size
  admin_username      = each.value.admin_username

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  admin_ssh_key {
  username   = each.value.admin_username
  public_key = each.value.ssh_public_key
}


  os_disk {
    name                 = each.value.os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

