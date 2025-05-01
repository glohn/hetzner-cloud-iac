data "hetznerdns_zone" "dns_zone" {
  name = var.domainname
}

resource "hetznerdns_record" "cert_validation" {
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "_acme-challenge.${var.project}.hcloud"
  type    = "TXT"
  value   = "validation_token"
  ttl     = 600
}

resource "hcloud_managed_certificate" "managed_certificate" {
  name         = "${var.project}.hcloud.${var.domainname}"
  domain_names = ["${var.project}.hcloud.${var.domainname}"]
}

