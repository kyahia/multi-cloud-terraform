variable "nat_name" {
    type = string
    default = "nat-gateway"
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
variable "vpc_id" {
    type = string
}
variable "private_subnet_ids" {
    type = map(string)
}
variable "public_subnet_id" {
    type = string
}
