variable "private_subnet_id" {
  type = string
}
variable "sg_id" {
  type = string
}
variable "vm_ami" {
  type = objetct({
    ami_name = string
    os_name = string
    os_version = string
  })
  defautl = {
    ami_name = ""
    os_name = "ubuntu"
    os_version = "18.04"
  }
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