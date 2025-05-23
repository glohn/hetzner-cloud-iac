output "server_id_rabbitmq" {
  description = "ID of the rabbitmq server"
  value       = var.server_type_rabbitmq != null ? [hcloud_server.vm-rabbitmq[0].id] : []
}

