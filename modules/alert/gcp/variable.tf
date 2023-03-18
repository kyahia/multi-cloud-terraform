variable "gcp_credentials" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "name" {
  type = string
}

variable "combiner" {
    type = string 
}

variable "condition" {
    type = map(any)
}

variable "notification" {
    type = map(any)
}

variable "load_balancer" {
  default = null
}