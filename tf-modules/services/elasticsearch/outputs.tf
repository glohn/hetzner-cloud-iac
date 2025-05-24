output "server_id_elasticsearch" {
  description = "ID of the Elasticsearch server"
  value       = try(hcloud_server.vm-elasticsearch[0].id, null)
}

