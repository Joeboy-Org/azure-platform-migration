variable "subscription_id" {
  type = string
}

variable "vm_admin_username" {
  type    = string
  default = "adminuser"
}

variable "windows_vm_admin_password" {
  type      = string
  sensitive = true
}

variable "environment" {
  type = string
}

variable "users" {
  type = list(string)
}
