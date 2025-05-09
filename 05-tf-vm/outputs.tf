output "server_ips" {
  description = "The public IPv4 address of the server"
  value       = module.server.ipv4_addresses
}

output "server_ids_sw_web" {
  description = "IDs of the Shopware web servers"
  value       = module.server.server_ids_sw_web
}

output "server_id_sw_admin" {
  description = "ID of the Shopware adminserver"
  value       = module.server.server_id_sw_admin
}

output "server_id_pim" {
  description = "ID of the pimcore server"
  value       = module.server.server_id_pim
}

output "server_type_sw_web" {
  description = "Hetzner server type to deploy, e.g. cx22"
  value       = var.server_type_sw_web
}

output "server_type_sw_admin" {
  description = "Hetzner server type to deploy, e.g. cx22"
  value       = var.server_type_sw_admin
}

output "server_type_pim" {
  description = "Hetzner server type to deploy, e.g. cx22"
  value       = var.server_type_pim
}

output "number_instances_sw_web" {
  description = "Number of Shopware webserver"
  value       = var.number_instances_sw_web
}

