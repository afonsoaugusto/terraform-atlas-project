variable "username" {}
variable "project_id" {}

variable "tags" {
  default = {}
  type    = map(any)
}

variable "linked_clusters" {
  default = []
  type    = list(any)
}


variable "list_db_name_privilege_dbAdmin" {
  default = []
  type    = list(any)
}

variable "list_db_name_privilege_read" {
  default = []
  type    = list(any)
}

variable "list_db_name_privilege_readWrite" {
  default = []
  type    = list(any)
}

variable "db_role_readAnyDatabase" {
  default = false
  type    = bool
}

variable "db_role_readWriteAnyDatabase" {
  default = false
  type    = bool
}

variable "db_role_clusterMonitor" {
  default = false
  type    = bool
}

variable "db_role_dbAdminAnyDatabase" {
  default = false
  type    = bool
}

variable "db_role_enableSharding" {
  default = false
}

variable "db_role_backup" {
  default = false
}

variable "db_role_atlasAdmin" {
  default = false
  type    = bool
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

  dynamic "roles" {
    for_each = toset(var.list_db_name_privilege_dbAdmin)
    content {
      role_name     = "dbAdmin"
      database_name = roles.key
    }
  }

  dynamic "roles" {
    for_each = toset(var.list_db_name_privilege_read)
    content {
      role_name     = "read"
      database_name = roles.key
    }
  }

  dynamic "roles" {
    for_each = toset(var.list_db_name_privilege_readWrite)
    content {
      role_name     = "readWrite"
      database_name = roles.key
    }
  }

  dynamic "labels" {
    for_each = var.tags
    content {
      key   = labels.key
      value = labels.value
    }
  }

  dynamic "scopes" {
    for_each = toset(var.linked_clusters)
    content {
      name = scopes.key
      type = "CLUSTER"
    }
  }
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