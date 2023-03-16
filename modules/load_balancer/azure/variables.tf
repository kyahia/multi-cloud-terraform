variable "resource_group_name" {
}

variable "location" {
}

variable "azure_subscription_id" {
}

variable "name" {
}

variable "capacity" {
    type = number
    default = 10
}

variable "subnet" {
}

variable "ports" {
}

variable "vms" {
}


variable "type" {
    default = "application"
}

variable "scheme" {
    default = "External"
}

variable "virtual_network_id" {
  
}

  
