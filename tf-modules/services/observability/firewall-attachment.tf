resource "hcloud_firewall_attachment" "firewall_attachment_observability" {
  count       = var.server_type_observability != null ? 1 : 0
  firewall_id = var.firewall_id_observability
  server_ids  = [hcloud_server.vm-observability[count.index].id]
} 