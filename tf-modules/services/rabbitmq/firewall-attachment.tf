resource "hcloud_firewall_attachment" "fw-rabbitmq" {
  count           = var.server_type_rabbitmq != null ? 1 : 0
  firewall_id     = var.firewall_id_rabbitmq
  label_selectors = ["service-type=rabbitmq"]
}

