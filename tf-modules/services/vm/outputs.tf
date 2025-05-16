output "server_id_bastion" {
  description = "ID of the bastion server"
  value       = [for i in range(var.server_type_bastion != null ? 1 : 0) : hcloud_server.vm-bastion[i].id]
}

output "server_ids_sw_web" {
  description = "IDs of the Shopware web servers"
  value       = [for key in keys(hcloud_server.vm-sw-web) : hcloud_server.vm-sw-web[key].id]
}

output "server_id_sw_admin" {
  description = "ID of the Shopware adminserver"
  value       = [for i in range(var.server_type_sw_admin != null ? 1 : 0) : hcloud_server.vm-sw-admin[i].id]
}

output "server_id_pim" {
  description = "ID of the pimcore server"
  value       = [for i in range(var.server_type_pim != null ? 1 : 0) : hcloud_server.vm-pim[i].id]
}

output "ipv4_addresses" {
  description = "Public IPv4 addresses of the created servers"
  value = concat(
    [for key in keys(hcloud_server.vm-sw-web) : hcloud_server.vm-sw-web[key].ipv4_address],
    [for i in range(var.server_type_sw_admin != null ? 1 : 0) : hcloud_server.vm-sw-admin[i].ipv4_address],
    [for i in range(var.server_type_pim != null ? 1 : 0) : hcloud_server.vm-pim[i].ipv4_address]
  )
}

