variable "subnetworks" {
  type = map(any)
  default = {}
}

variable "vpc_name" {
  type = string
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