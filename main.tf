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

locals {
  project_atlas_name = format("%s-%s", var.project_name, var.env)
}

module "project" {
  source = "./modules/project"
  name   = local.project_atlas_name
  org_id = var.org_id
}