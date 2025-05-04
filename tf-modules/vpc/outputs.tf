output "network_id" {
  description = "The ID of the private network"
  value       = hcloud_network.private-network.id
}

output "subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in hcloud_network_subnet.private-subnet : subnet.id]
}

#output "subnet_ip_ranges" {
#  description = "The IP ranges of the private subnets"
#  value       = [for i in range(var.subnet_count) : hcloud_network_subnet.private-subnet[i].ip_range]
#}

