output "ipv4_address" {
  description = "Public IPv4 address of the created server"
  value       = hcloud_server.instance.ipv4_address
}

