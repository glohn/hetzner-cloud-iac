output "load_balancer_sw_web_ipv4" {
  description = "IPv4 address of the Shopware web load balancer"
  value       = length(hcloud_load_balancer.load_balancer_sw_web) > 0 ? hcloud_load_balancer.load_balancer_sw_web[0].ipv4 : null
}

output "load_balancer_sw_admin_ipv4" {
  description = "IPv4 address of the Shopware admin load balancer"
  value       = length(hcloud_load_balancer.load_balancer_sw_admin) > 0 ? hcloud_load_balancer.load_balancer_sw_admin[0].ipv4 : null
}

output "load_balancer_pim_ipv4" {
  description = "IPv4 address of the Pimcore load balancer"
  value       = length(hcloud_load_balancer.load_balancer_pim) > 0 ? hcloud_load_balancer.load_balancer_pim[0].ipv4 : null
}

