output "network_id" {
  description = "The ID of the private network"
  value       = module.vpc.network_id
}

output "subnet_id" {
  description = "The subnet ID of the private network"
  value       = module.vpc.subnet_ids
}

output "subnet_ip_ranges" {
  description = "The IP ranges of the private subnets"
  value       = module.vpc.subnet_ip_ranges
}

output "firewall_ids" {
  description = "ID of the firewall"
  value       = module.firewall.firewall_ids
}

output "load_balancer_id" {
  description = "The ID of the load balancer"
  value       = module.loadbalancer.load_balancer_id
}

output "load_balancer_ipv4" {
  description = "IPv4 of the load balancer"
  value = module.loadbalancer.load_balancer_ipv4
}

output "managed_certificate_id" {
  description = "ID of the managed certificate"
  value       = module.certificate.managed_certificate_id
}

