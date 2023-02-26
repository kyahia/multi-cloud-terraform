# AZURE
variable "azure_subscription_id" {
  type = string
}
variable "azure_resource_group" {
  type = string
}
variable "azure_location" {
  type = string
  default = "Central US"
}

# GCP
variable "gcp_credentials_path" {
  type = string
}

variable "gcp_region" {
  type = string
  default = "us-central1"
}

# AWS
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}
