variable "vms" {
  type = list(object({
    name           = string
    os_disk_name   = string
    size           = string
    admin_username = string
    ports          = list(number)
  }))
}
variable "resource_group" {}
variable "location" {}
