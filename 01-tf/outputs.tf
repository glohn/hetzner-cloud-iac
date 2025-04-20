output "server_ip" {
  description = "The public IPv4 address of the test server"
  value       = hcloud_server.test.ipv4_address
}

