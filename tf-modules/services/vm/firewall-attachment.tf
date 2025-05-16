locals {
  server_ids_all = compact(concat(
    [for key in keys(hcloud_server.vm-sw-web) : hcloud_server.vm-sw-web[key].id],
    var.server_type_sw_admin != null ? [hcloud_server.vm-sw-admin[0].id] : [],
    var.server_type_pim != null ? [hcloud_server.vm-pim[0].id] : [],
    var.server_type_bastion != null ? [hcloud_server.vm-bastion[0].id] : []
  ))
}

resource "hcloud_firewall_attachment" "fw-ssh" {
  firewall_id = var.firewall_id_ssh
  server_ids  = local.server_ids_all
}

