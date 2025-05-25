locals {
  source_load_balancer_ips = compact(concat(
    length(hcloud_load_balancer.load_balancer_sw_web) > 0 ? [hcloud_load_balancer.load_balancer_sw_web[0].ipv4] : [],
    length(hcloud_load_balancer.load_balancer_sw_admin) > 0 ? [hcloud_load_balancer.load_balancer_sw_admin[0].ipv4] : [],
    length(hcloud_load_balancer.load_balancer_pim) > 0 ? [hcloud_load_balancer.load_balancer_pim[0].ipv4] : []
  ))
  # Check if any load balancer should be created based on input variables
  create_loadbalancer = var.server_type_sw_web != null || var.server_type_sw_admin != null || var.server_type_pim != null
  # Check if any servers should exist based on input variables
  has_servers = var.number_instances_sw_web > 0 || var.server_type_sw_admin != null || var.server_type_pim != null
}

resource "hcloud_firewall" "fw-http" {
  count = local.create_loadbalancer ? 1 : 0
  name  = "${var.project}-fw-http"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.http_port
    source_ips = local.source_load_balancer_ips
  }
}

resource "hcloud_firewall_attachment" "fw-http" {
  count           = local.create_loadbalancer && local.has_servers ? 1 : 0
  firewall_id     = hcloud_firewall.fw-http[0].id
  label_selectors = ["vm-role=web-service"]
}

