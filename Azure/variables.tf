variable "location" {
  default     = "east us"
  description = "Location of the resource"
}

variable "resource_group" {
  default = "rg-ceq-us-renaissance-poc"
}

variable "vnet_name" {
  default = "ren-linux-vnet"
}

variable "password" {
  default     = "User12345678"
  description = "password for the VM"
}

variable "vm_count" {
  description = "Number of VMs to create"
  default     = 5
}
