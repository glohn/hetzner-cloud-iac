resource "hcloud_firewall_attachment" "fw-nfs" {
  count           = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0
  firewall_id     = var.firewall_id_nfs
  label_selectors = ["service-type=nfs"]
}

