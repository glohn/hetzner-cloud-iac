data "hetznerdns_zone" "dns_zone" {
  name = var.domainname
}

resource "hetznerdns_record" "dns_endpoint_alb" {
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "${var.project}.hcloud"
  type    = "A"
  value   = var.load_balancer_ipv4
  ttl     = 600
}

