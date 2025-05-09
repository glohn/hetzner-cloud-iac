#output "load_balancer_id" {
#  description = "The ID of the load balancer"
#  value       = hcloud_load_balancer.load_balancer.id
#}

output "load_balancer_sw_web_ipv4" {
  description = "The IPv4 of the load balancer sw web"
  value       = var.server_type_sw_web != null ? hcloud_load_balancer.load_balancer_sw_web[0].ipv4 : null
}

output "load_balancer_sw_admin_ipv4" {
  description = "The IPv4 of the load balancer sw admin"
  value       = var.server_type_sw_admin != null ? hcloud_load_balancer.load_balancer_sw_admin[0].ipv4 : null
}

output "load_balancer_pim_ipv4" {
  description = "The IPv4 of the load balancer pim"
  value       = var.server_type_pim != null ? hcloud_load_balancer.load_balancer_pim[0].ipv4 : null
}

