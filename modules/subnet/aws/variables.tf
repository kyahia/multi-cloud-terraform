variable "subnets" {
    type = map(any)
}
variable "vpc_id" {
    type = string
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "internet_gateway_id" {
  type = string
  default = ""
}

variable "cidr_mode" {
  default = "auto"
}