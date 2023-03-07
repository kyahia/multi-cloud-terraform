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
variable "ngw_name" {
  type = string
}
variable "igw_name" {
  type = string
}