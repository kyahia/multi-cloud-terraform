variable "subnets" {
  type = map(any)
}

variable "vpc_name" {
  type = string
}

variable "gcp_credentials" {
}

variable "gcp_project_id" {
}

variable "gcp_region" {
}

variable "cidr_mode" {
  default = "manual"
}

variable "previous_subnets" {
  default = []
}
