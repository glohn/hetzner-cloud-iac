output "server_ids" {
  description = "IDs of the Shopware web servers"
  value       = [for i in range(var.number_instances_sw_web) : hcloud_server.vm-sw-web[i].id]
}

output "ipv4_addresses" {
  description = "Public IPv4 addresses of the created shopware webservers"
  value       = [for i in range(var.number_instances_sw_web) : hcloud_server.vm-sw-web[i].ipv4_address]
}

