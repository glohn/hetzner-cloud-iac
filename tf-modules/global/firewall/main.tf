resource "hcloud_firewall" "fw-vm-ssh" {
  name = "${var.project}-fw-vm-ssh"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.ssh_port
    source_ips = var.allowed_ssh_ips
  }
}

resource "hcloud_firewall" "fw-services-ssh" {
  name = "${var.project}-fw-services-ssh"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.ssh_port
    source_ips = var.allowed_ssh_ips
  }
}

resource "hcloud_firewall" "fw-elasticsearch" {
  name = "${var.project}-fw-elasticsearch"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.elastic_port
    source_ips = var.subnet_cidrs
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.elastic_dashboard_port
    source_ips = var.allowed_ssh_ips
  }
}

resource "hcloud_firewall" "fw-nfs" {
  name = "${var.project}-fw-nfs"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.nfs_port
    source_ips = var.subnet_cidrs
  }
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

resource "hcloud_firewall" "fw-rds" {
  name = "${var.project}-fw-rds"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.rds_port
    source_ips = var.subnet_cidrs
  }
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

