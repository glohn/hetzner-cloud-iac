output "server_ip" {
  description = "The public IPv4 address of the server"
  value       = module.server.ipv4_address
}

