terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "4.53.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

locals {
  gcp_credentials = file(var.gcp_credentials_path)
  gcp_project_id = jsondecode(file(var.gcp_credentials_path)).project_id
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  skip_provider_registration = true
}

# Configure the GCP Provider
provider "google" {
  credentials = local.gcp_credentials
  project = local.gcp_project_id
  region = var.gcp_region
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}