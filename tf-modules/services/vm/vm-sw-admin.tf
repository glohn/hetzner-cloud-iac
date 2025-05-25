data "cloudinit_config" "user-data-sw-admin" {
  count = var.server_type_sw_admin != null ? 1 : 0

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-sw-admin" {
  count = var.server_type_sw_admin != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-admin"
  server_type = var.server_type_sw_admin
  image       = var.default_image
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  labels = {
    service-type = "vm"
    vm-role      = "web-service"
    environment  = var.project
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-sw-admin[count.index].rendered
}

resource "hcloud_server_network" "vm_sw_admin_network" {
  count      = var.server_type_sw_admin != null ? 1 : 0
  server_id  = hcloud_server.vm-sw-admin[count.index].id
  network_id = var.network_id
}

