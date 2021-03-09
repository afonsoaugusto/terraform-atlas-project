variable "project_id" {}

variable "type" {
  default = "shared"
  type    = string
  validation {
    condition     = contains(["shared", "dedicated", "multi_cloud", "multi_region"], var.type)
    error_message = "Valid values for var: type are (shared, dedicted, multi_cloud, multi_region)"
  }
}

variable "tags" {
  default = {}
  type    = map(any)
}

variable "db_role_atlasAdmin" {
  default = false
  type    = bool
}

locals {
}


resource "mongodbatlas_cluster" "cluster" {

  dynamic "scopes" {
    for_each = toset(var.linked_clusters)
    content {
      name = scopes.key
      type = "CLUSTER"
    }
  }
}

output "cluster_id" {
  value       = mongodbatlas_cluster.cluster.cluster_id
  description = "The cluster ID."
}

output "mongo_db_version" {
  value       = mongodbatlas_cluster.cluster.mongo_db_version
  description = "Version of MongoDB the cluster runs, in major-version.minor-version format."
}

output "id" {
  value       = mongodbatlas_cluster.cluster.id
  description = "The Terraform's unique identifier used internally for state management."
}

output "mongo_uri" {
  value       = mongodbatlas_cluster.cluster.mongo_uri
  description = "Base connection string for the cluster. Atlas only displays this field after the cluster is operational, not while it builds the cluster."
}

output "connection_strings" {
  value       = mongodbatlas_cluster.cluster.connection_strings
  description = "Set of connection strings that your applications use to connect to this cluster."
}

output "state_name" {
  value       = mongodbatlas_cluster.cluster.state_name
  description = "Current state of the cluster."
}
