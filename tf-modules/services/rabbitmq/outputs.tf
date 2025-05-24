output "server_id_rabbitmq" {
  description = "ID of the RabbitMQ server"
  value       = try(hcloud_server.vm-rabbitmq[0].id, null)
}

