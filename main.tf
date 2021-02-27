terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the MongoDB Atlas Provider
provider "mongodbatlas" {
}

variable "org_id" {}
variable "env" {}
variable "project_name" {}
variable "cidr" {}
variable "user_application" {}

locals {
  project_atlas_name = format("%s-%s", var.project_name, var.env)
}

module "project" {
  source = "./modules/project"
  name   = local.project_atlas_name
  org_id = var.org_id
}

module "network_access" {
  source     = "./modules/network_access"
  cidr       = var.cidr
  project_id = module.project.id
}

module "database_access_user_application" {
  source     = "./modules/database_access"
  username   = var.user_application
  project_id = module.project.id
}