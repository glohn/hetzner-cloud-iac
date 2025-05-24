resource "hcloud_firewall_attachment" "fw-redis" {
  count          = var.server_type_redis != null ? 1 : 0
  firewall_id    = var.firewall_id_redis
  label_selectors = ["service-type=redis"]
}

