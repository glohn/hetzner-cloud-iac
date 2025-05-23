output "server_id_redis" {
  description = "ID of the redis server"
  value       = var.server_type_redis != null ? [hcloud_server.vm-redis[0].id] : []
}

