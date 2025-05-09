data "cloudinit_config" "user-data-sw-web" {
  count = var.number_instances_sw_web

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-sw-web" {
  count = var.number_instances_sw_web

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  name        = "${var.project}-web${count.index + 1}"
  server_type = var.server_type_sw_web
  image       = "debian-12"
  location    = var.location
  ssh_keys    = values(var.ssh_key_ids)
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-sw-web[count.index].rendered
}

resource "hcloud_server_network" "vm_sw_web_network" {
  count      = var.number_instances_sw_web
  server_id  = hcloud_server.vm-sw-web[count.index].id
  network_id = var.network_id
}

