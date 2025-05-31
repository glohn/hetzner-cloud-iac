data "hetznerdns_zone" "dns_zone" {
  name = var.domainname
}

locals {
  subdomains = [
    "${var.project}",
    "admin.${var.project}",
    "pim.${var.project}",
    "monitoring.${var.project}"
  ]

  cert_domains = [
    for sub in local.subdomains : "${sub}.hcloud.${var.domainname}"
  ]
}

resource "hetznerdns_record" "cert_validation" {
  for_each = toset(local.subdomains)

  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = "_acme-challenge.${each.key}.hcloud"
  type    = "TXT"
  value   = "validation_token"
  ttl     = 600
}

resource "hcloud_managed_certificate" "managed_certificate" {
  name         = "${var.project}.hcloud.${var.domainname}"
  domain_names = local.cert_domains
}

