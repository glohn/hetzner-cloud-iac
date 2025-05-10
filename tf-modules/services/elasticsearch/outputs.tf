output "server_id_elasticsearch" {
  description = "ID of the elasticsearch server"
  value       = [for i in range(var.server_type_elasticsearch != null ? 1 : 0) : hcloud_server.vm-elasticsearch[i].id]
}

