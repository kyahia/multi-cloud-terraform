# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }

#     # aws = {
#     #   source  = "hashicorp/aws"
#     #   version = "~> 4.16"
#     # }

#     # google = {
#     #   source  = "hashicorp/google"
#     #   version = "4.53.1"
#     # }
#   }
# }

# locals {
#   gcp_credentials = file(var.gcp_credentials_path)
#   gcp_project_id  = jsondecode(file(var.gcp_credentials_path)).project_id
# }

# # Configure the GCP Provider
# provider "google" {
#   credentials = local.gcp_credentials
#   project     = local.gcp_project_id
#   region      = var.gcp_region
# }



