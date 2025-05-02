resource "hcloud_firewall" "fw-ssh" {
  name = "${var.project}-fw-ssh"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.allowed_ssh_ips
  }
}

resource "hcloud_firewall" "fw-elasticsearch" {
  name = "${var.project}-fw-elasticsearch"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.elastic_port
    source_ips = [var.source_ips]
  }
}

resource "hcloud_firewall" "fw-http" {
  name = "${var.project}-fw-http"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.http_port
    source_ips = [var.load_balancer_ipv4]
  }
}

resource "hcloud_firewall" "fw-rds" {
  name = "${var.project}-fw-rds"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.rds_port
    source_ips = [var.source_ips]
  }
}

resource "hcloud_firewall" "fw-redis" {
  name = "${var.project}-fw-redis"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.redis_port
    source_ips = [var.source_ips]
  }
}

