variable "gcp_credentials" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "zone" {
  type = string
}

/* variable "vpc_name" {
  
} */

variable "type" {
    type = string
}

variable "target_vms" {
}

variable "port" {
    type = string
}

variable "port_name" {
    type = string
}

variable "name" {
    type = string
}

variable "health_check" {
    type = map(any)
    default = null
}


variable "scheme" {
  
}

