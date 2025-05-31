resource "hcloud_firewall_attachment" "fw-rds" {
  count           = var.server_type_rds != null ? 1 : 0
  firewall_id     = var.firewall_id_rds
  label_selectors = ["service-type=rds"]
}

