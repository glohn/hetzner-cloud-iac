locals {
  server_ids = compact(concat(
    var.server_ids_sw_web,
    var.server_id_sw_admin,
    var.server_id_pim
  ))

  source_load_balancer_ips = compact(concat(
    [var.load_balancer_sw_web_ipv4],
    [var.load_balancer_sw_admin_ipv4],
    [var.load_balancer_pim_ipv4]
  ))
}

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

resource "hcloud_firewall_attachment" "fw-ssh" {
  count       = length(local.server_ids) > 0 ? 1 : 0
  firewall_id = hcloud_firewall.fw-ssh.id
  server_ids  = local.server_ids
}

resource "hcloud_firewall" "fw-elasticsearch" {
  name = "${var.project}-fw-elasticsearch"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.elastic_port
    source_ips = var.subnet_cidrs
  }
}

resource "hcloud_firewall_attachment" "fw-elasticsearch" {
  count       = length(var.server_id_elasticsearch)
  firewall_id = hcloud_firewall.fw-elasticsearch.id
  server_ids  = [var.server_id_elasticsearch[count.index]]
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
  count       = length(local.server_ids) > 0 ? 1 : 0
  firewall_id = hcloud_firewall.fw-http.id
  server_ids  = local.server_ids
}

resource "hcloud_firewall" "fw-rabbitmq" {
  name = "${var.project}-fw-rabbitmq"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.rabbitmq_port
    source_ips = var.subnet_cidrs
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.rabbitmq_mgmt_port
    source_ips = var.allowed_ssh_ips
  }
}

resource "hcloud_firewall_attachment" "fw-rabbitmq" {
  count       = length(var.server_id_rabbitmq)
  firewall_id = hcloud_firewall.fw-rabbitmq.id
  server_ids  = [var.server_id_rabbitmq[count.index]]
}

resource "hcloud_firewall" "fw-rds" {
  name = "${var.project}-fw-rds"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.rds_port
    source_ips = var.subnet_cidrs
  }
}

resource "hcloud_firewall_attachment" "fw-rds" {
  count       = length(var.server_id_rds)
  firewall_id = hcloud_firewall.fw-rds.id
  server_ids  = [var.server_id_rds[count.index]]
}

resource "hcloud_firewall" "fw-redis" {
  name = "${var.project}-fw-redis"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.redis_port
    source_ips = var.subnet_cidrs
  }
}

resource "hcloud_firewall_attachment" "fw-redis" {
  count       = length(var.server_id_redis)
  firewall_id = hcloud_firewall.fw-redis.id
  server_ids  = [var.server_id_redis[count.index]]
}

