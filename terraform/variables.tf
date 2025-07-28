variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
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
