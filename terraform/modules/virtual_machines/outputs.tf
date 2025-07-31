output "public_ips" {
  value = {
    for name, pip in azurerm_public_ip.pip :
    replace(name, "-pip", "") => pip.ip_address
  }
}

output "admin_usernames" {
  value = {
    for vm in azurerm_linux_virtual_machine.vm : vm.name => vm.admin_username
  }
}