resource "hcloud_server" "vm-sw-web" {
  count = var.number_instances_sw_web

  name        = "${var.project}-web${count.index + 1}"
  server_type = var.server_type_sw_web
  image       = "debian-12"
  location    = var.location
  ssh_keys    = [for key in hcloud_ssh_key.ssh_keys : key.id]
  network {
    network_id = var.network_id
  }
  backups = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

