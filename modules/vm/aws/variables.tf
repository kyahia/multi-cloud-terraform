variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "open_ports" {
  type = list
  default = []
}
variable "architecture" {
  type = string
  default = "x86_64"
}

variable "ssh_key" {
  default = ""
}

variable "configuration" {
  default = "auto"
}

variable "vms" {
  
}
