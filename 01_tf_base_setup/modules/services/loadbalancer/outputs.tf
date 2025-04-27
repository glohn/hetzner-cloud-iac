output "load_balancer_id" {
  description = "The ID of the load balancer"
  value       = hcloud_load_balancer.load_balancer.id
}

output "load_balancer_ipv4" {
  description = "The IPv4 of the load balancer"
  value       = hcloud_load_balancer.load_balancer.ipv4
}

