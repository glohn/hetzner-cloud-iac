data "hetznerdns_zone" "dns_zone" {
  name = var.domainname
}

resource "hetznerdns_record" "dns_endpoint_sw_web_lb" {
  count   = var.server_type_sw_web != null ? 1 : 0
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "${var.project}.hcloud"
  type    = "A"
  value   = var.load_balancer_sw_web_ipv4
  ttl     = 600
}

resource "hetznerdns_record" "dns_endpoint_sw_admin_lb" {
  count   = var.server_type_sw_admin != null ? 1 : 0
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "${var.project}-admin.hcloud"
  type    = "A"
  value   = var.load_balancer_sw_admin_ipv4
  ttl     = 600
}

resource "hetznerdns_record" "dns_endpoint_pim_lb" {
  count   = var.server_type_pim != null ? 1 : 0
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "${var.project}-pim.hcloud"
  type    = "A"
  value   = var.load_balancer_pim_ipv4
  ttl     = 600
}

