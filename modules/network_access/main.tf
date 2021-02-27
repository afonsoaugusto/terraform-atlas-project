variable "cidr" {}
variable "project_id" {}

variable "comment" {
  default = ""
}

locals {
  default_comment = format("%s Open access for %s", var.project_id, var.cidr)
  comment         = var.comment == "" ? local.default_comment : var.comment
}


resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  project_id = var.project_id
  cidr_block = var.cidr
  comment    = local.comment
}

output "id" {
  value = mongodbatlas_project_ip_access_list.ip_access_list.id
}