variable "subscription_id" {
  description = "Azure subscription ID to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project name used in resource naming"
  type        = string
  default     = "apm"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnets" {
  description = "Subnet definitions"
  type = map(object({
    address_prefix = string
  }))
  default = {
    web  = { address_prefix = "10.1.1.0/24" }
    app  = { address_prefix = "10.1.2.0/24" }
    data = { address_prefix = "10.1.3.0/24" }
  }
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into Linux VMs"
  type        = list(string)
}

variable "allowed_rdp_cidrs" {
  description = "CIDR blocks allowed to RDP into Windows VMs"
  type        = list(string)
}

variable "linux_vm_size" {
  description = "SKU size for Linux VM"
  type        = string
  default     = "Standard_B2s"
}

variable "windows_vm_size" {
  description = "SKU size for Windows VM"
  type        = string
  default     = "Standard_B4ms"
}

variable "vm_admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "adminuser"
}

variable "vm_admin_password" {
  description = "Admin password for Linux VM"
  type        = string
  sensitive   = true
}

variable "windows_vm_admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}
