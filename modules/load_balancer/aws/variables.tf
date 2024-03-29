variable "aws_access_key" {
    type = string
}
variable "aws_secret_key" {
    type = string
}
variable "aws_region" {
}
variable "vpc_id" {
    type = string
}
variable "subnets" {
    type = list(string)
}
variable "sg_id" {
    type = string
    default = ""
}
variable "vm_ids" {
    type = map(string)
}
variable "scheme" {
    type = string
    default = "external"
}
variable "type" {
    type = string
}