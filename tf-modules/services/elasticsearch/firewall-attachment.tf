resource "hcloud_firewall_attachment" "fw-elasticsearch" {
  count          = var.server_type_elasticsearch != null ? 1 : 0
  firewall_id    = var.firewall_id_elasticsearch
  label_selectors = ["service-type=elasticsearch"]
}

