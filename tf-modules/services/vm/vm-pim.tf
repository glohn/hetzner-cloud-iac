data "cloudinit_config" "user-data-pim" {
  count = var.server_type_pim != null ? 1 : 0

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-pim" {
  count = var.server_type_pim != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  name        = "${var.project}-pim"
  server_type = var.server_type_pim
  image       = "debian-12"
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-pim[count.index].rendered
}

resource "hcloud_server_network" "vm_pim_network" {
  count      = var.server_type_pim != null ? 1 : 0
  server_id  = hcloud_server.vm-pim[count.index].id
  network_id = var.network_id
}

