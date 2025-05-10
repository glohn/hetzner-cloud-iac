output "network_id" {
  description = "The ID of the private network"
  value       = hcloud_network.private-network.id
}

output "subnet_cidrs" {
  description = "CIDRs of the private subnets"
  value       = [for subnet in hcloud_network_subnet.private-subnet : subnet.ip_range]
}

