variable "vms" {
    type = map(any) 
}

variable "gcp_credentials" {
    type = string
}

variable "gcp_project_id" {
    type = string
}

variable "gcp_region" {
    type = string
}

variable "vpc_name" {
    type = string
}