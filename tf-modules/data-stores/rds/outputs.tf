output "server_id_rds" {
  description = "ID of the rds server"
  value       = var.server_type_rds != null ? [hcloud_server.vm-rds[0].id] : []
}

