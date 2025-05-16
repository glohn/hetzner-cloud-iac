locals {
  source_load_balancer_ips = compact(concat(
    length(hcloud_load_balancer.load_balancer_sw_web) > 0 ? [hcloud_load_balancer.load_balancer_sw_web[0].ipv4] : [],
    length(hcloud_load_balancer.load_balancer_sw_admin) > 0 ? [hcloud_load_balancer.load_balancer_sw_admin[0].ipv4] : [],
    length(hcloud_load_balancer.load_balancer_pim) > 0 ? [hcloud_load_balancer.load_balancer_pim[0].ipv4] : []
  ))
  server_ids = compact(concat(
    var.server_ids_sw_web != null ? var.server_ids_sw_web : [],
    var.server_id_sw_admin != null ? var.server_id_sw_admin : [],
    var.server_id_pim != null ? var.server_id_pim : []
  ))
}

resource "hcloud_firewall" "fw-http" {
  name = "${var.project}-fw-http"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.http_port
    source_ips = local.source_load_balancer_ips
  }
}

resource "hcloud_firewall_attachment" "fw-http" {
  firewall_id = hcloud_firewall.fw-http.id
  server_ids  = local.server_ids
}

