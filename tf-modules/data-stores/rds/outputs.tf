output "server_id_rds" {
  description = "ID of the rds server"
  value       = [for i in range(var.server_type_rds != null ? 1 : 0) : hcloud_server.vm-rds[i].id]
}

