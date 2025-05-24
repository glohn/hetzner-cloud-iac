output "server_id_redis" {
  description = "ID of the Redis server"
  value       = try(hcloud_server.vm-redis[0].id, null)
}

