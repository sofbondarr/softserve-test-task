variable "vms" {
  type = list(object({
    name           = string
    os_disk_name   = string
    size           = string
    admin_username = string
    ports          = list(number)
    ssh_public_key = string
  }))
}
variable "resource_group" {}
variable "location" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = map(string)
}
