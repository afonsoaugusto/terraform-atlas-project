variable "username" {}
variable "project_id" {}

variable "list_db_name_privilege_dbAdmin" {
  default = []
}

variable "list_db_name_privilege_read" {
  default = []
}

variable "list_db_name_privilege_readWrite" {
  default = []
}

variable "db_role_readAnyDatabase" {
  default = false
}

variable "db_role_readWriteAnyDatabase" {
  default = false
}

variable "db_role_clusterMonitor" {
  default = false
}

variable "db_role_dbAdminAnyDatabase" {
  default = false
}

variable "db_role_enableSharding" {
  default = false
}

variable "db_role_backup" {
  default = false
}

variable "db_role_atlasAdmin" {
  default = false
}

locals {
  map_roles_admin = map(
    "readAnyDatabase", var.db_role_readAnyDatabase,
    "readWriteAnyDatabase", var.db_role_readWriteAnyDatabase,
    "clusterMonitor", var.db_role_clusterMonitor,
    "dbAdminAnyDatabase", var.db_role_dbAdminAnyDatabase,
    "enableSharding", var.db_role_enableSharding,
    "backup", var.db_role_backup,
    "atlasAdmin", var.db_role_atlasAdmin,

  )
  filter_roles_admin_enabled = matchkeys(keys(local.map_roles_admin), values(local.map_roles_admin), ["true"])
}

output "list_priv" {
  value = local.filter_roles_admin_enabled
}

# dynamic privileges for user
locals {
  user_privileges = map("admin", "readAnyDatabase")
  # user_privileges  = list(local.user_privileges_map)
}

resource "random_password" "password" {
  length  = 30
  special = true
}

resource "mongodbatlas_database_user" "user" {
  username           = var.username
  password           = random_password.password.result
  project_id         = var.project_id
  auth_database_name = "admin"

  dynamic "roles" {
    for_each = local.user_privileges
    content {
      role_name     = roles.value
      database_name = roles.key
    }
  }

  labels {
    key   = "My Key"
    value = "My Value"
  }

  # scopes {
  #   name = "My cluster name"
  #   type = "CLUSTER"
  # }

  # scopes {
  #   name = "My second cluster name"
  #   type = "CLUSTER"
  # }
}

output "id" {
  value       = mongodbatlas_database_user.user.id
  description = "The user id."
}

output "password" {
  value       = random_password.password.result
  description = "The user password."
  sensitive   = true
}