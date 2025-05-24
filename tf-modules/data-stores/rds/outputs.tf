output "server_id_rds" {
  description = "ID of the RDS server"
  value       = try(hcloud_server.vm-rds[0].id, null)
}

