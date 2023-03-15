variable "azure_subscription_id" {
}

variable "azure_resource_group" {
}

variable "name" {
}

variable "window_size" {
    type = string
    default = "PT1M"
}

variable "threshold" {
    type = number
    default = 10
}

variable "severity" {
  type = number
  default = 0
}

variable "load_balancer_id" {
}
