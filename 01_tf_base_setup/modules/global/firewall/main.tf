resource "hcloud_firewall" "firewall" {
  name = "${var.project}-firewall"

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

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = [var.load_balancer_ipv4]
  }

  rule {
    direction = "out"
    protocol  = "tcp"
    port      = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol  = "udp"
    port      = "any"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol  = "icmp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}

