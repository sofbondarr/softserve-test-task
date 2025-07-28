output "public_ips" {
  value = {
    for vm in azurerm_public_ip.pip : vm.name => vm.ip_address
  }
}
