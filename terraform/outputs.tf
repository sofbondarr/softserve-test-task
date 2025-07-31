output "vm1_ip" {
  value = module.virtual_machines.public_ips["VM1"]
}

output "vm2_ip" {
  value = module.virtual_machines.public_ips["VM2"]
}

output "vm1_user" {
  value = module.virtual_machines.admin_usernames["VM1"]
}

output "vm2_user" {
  value = module.virtual_machines.admin_usernames["VM2"]
}

output "vm1_ssh_key_path" {
  value = pathexpand("~/.ssh/vm1_key")
}

output "vm2_ssh_key_path" {
  value = pathexpand("~/.ssh/vm2_key")
}
