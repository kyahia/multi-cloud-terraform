variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "vm_username" {
  type = string
  default = "adminuser"
}

variable "vm_password" {
  type = string
  default = "yahiaKERDACHE2023"
}