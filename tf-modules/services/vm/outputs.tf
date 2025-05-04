output "server_ids_sw_web" {
  description = "IDs of the Shopware web servers"
  value       = [for i in range(var.number_instances_sw_web) : hcloud_server.vm-sw-web[i].id]
}

output "server_id_sw_admin" {
  description = "ID of the Shopware adminserver"
  value       = [for i in range(var.server_type_sw_admin != null ? 1 : 0) : hcloud_server.vm-sw-admin[i].id]
}

#output "server_id_pim" {
#  description = "ID of the pimcore server"
#  value       = [for i in range(var.server_type_pim != null ? 1 : 0) : hcloud_server.vm-pim[i].id]
#}

output "ipv4_addresses" {
  description = "Public IPv4 addresses of the created shopware webservers and admin servers"
  value = concat(
    [for i in range(var.number_instances_sw_web) : hcloud_server.vm-sw-web[i].ipv4_address],
    [for i in range(var.server_type_sw_admin != null ? 1 : 0) : hcloud_server.vm-sw-admin[i].ipv4_address]
  )
}

