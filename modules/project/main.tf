variable "name" {}
variable "org_id" {}

resource "mongodbatlas_project" "project" {
  name   = var.name
  org_id = var.org_id
}

output "id" {
  value       = mongodbatlas_project.project.id
  description = "The project id."
}

output "created" {
  value       = mongodbatlas_project.project.created
  description = "The ISO-8601-formatted timestamp of when Atlas created the project."
}

output "cluster_count" {
  value       = mongodbatlas_project.project.cluster_count
  description = "The number of Atlas clusters deployed in the project."
}