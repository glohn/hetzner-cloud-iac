data "cloudinit_config" "user-data-rabbitmq" {
  count = var.server_type_rabbitmq != null ? 1 : 0

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../services/vm/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-rabbitmq" {
  count = var.server_type_rabbitmq != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  name        = "${var.project}-rabbitmq"
  server_type = var.server_type_rabbitmq
  image       = "debian-12"
  location    = var.location
  ssh_keys    = values(var.ssh_key_ids)
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-rabbitmq[count.index].rendered
}

resource "hcloud_server_network" "vm_rabbitmq_network" {
  count      = var.server_type_rabbitmq != null ? 1 : 0
  server_id  = hcloud_server.vm-rabbitmq[count.index].id
  network_id = var.network_id
}

