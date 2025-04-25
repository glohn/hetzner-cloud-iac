output "ipv4_address" {
  description = "Public IPv4 address of the created server"
  value       = hcloud_server.instance.ipv4_address
}

output "id" {
  description = "ID of the created server"
  value       = hcloud_server.instance.id
}

output "ssh_key_id" {
  description = "ID of the uploaded SSH key"
  value       = hcloud_ssh_key.default.id
}

