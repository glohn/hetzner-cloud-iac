output "server_id_redis" {
  description = "ID of the redis server"
  value       = [for i in range(var.server_type_redis != null ? 1 : 0) : hcloud_server.vm-redis[i].id]
}

