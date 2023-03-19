variable "gcp_credentials" {
}

variable "gcp_project_id" {
}

variable "gcp_region" {
}
variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = map(any)
}

variable "previous_subnets" {
  default = []
}
