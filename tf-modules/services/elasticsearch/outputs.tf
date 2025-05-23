output "server_id_elasticsearch" {
  description = "ID of the elasticsearch server"
  value       = var.server_type_elasticsearch != null ? [hcloud_server.vm-elasticsearch[0].id] : []
}

