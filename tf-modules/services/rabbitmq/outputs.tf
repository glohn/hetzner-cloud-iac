output "server_id_rabbitmq" {
  description = "ID of the rabbitmq server"
  value       = [for i in range(var.server_type_rabbitmq != null ? 1 : 0) : hcloud_server.vm-rabbitmq[i].id]
}

