data "cloudinit_config" "user-data-redis" {
  count = var.server_type_redis != null ? 1 : 0

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../services/vm/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-redis" {
  count = var.server_type_redis != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  name        = "${var.project}-redis"
  server_type = var.server_type_redis
  image       = "debian-12"
  location    = var.location
  ssh_keys    = values(var.ssh_key_ids)
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-redis[count.index].rendered
}

resource "hcloud_server_network" "vm_redis_network" {
  count      = var.server_type_redis != null ? 1 : 0
  server_id  = hcloud_server.vm-redis[count.index].id
  network_id = var.network_id
}

