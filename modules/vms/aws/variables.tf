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
variable "private_subnet_id" {
  type = string
}
variable "available_ports" {
  type = map(
            object({
              port_number=number
              })
              )
}
variable "cpu_architecture" {
  type = string
}
variable "cpu_cores" {
  type = number
}
variable "vm_ram" {
  type = number
}
variable "os_name" {
  type = string
  default = "ubuntu"
}
variable "os_version" {
  type = string
  default = "20.04"
}
variable "ami_name" {
  type = string
  default = ""
}
variable "vm_number" {
  type = number
}
