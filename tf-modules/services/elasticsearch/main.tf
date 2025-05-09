data "cloudinit_config" "user-data-elasticsearch" {
  count = var.server_type_elasticsearch != null ? 1 : 0

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../../services/vm/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-elasticsearch" {
  count = var.server_type_elasticsearch != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  name        = "${var.project}-elasticsearch"
  server_type = var.server_type_elasticsearch
  image       = "debian-12"
  location    = var.location
  ssh_keys    = values(var.ssh_key_ids)
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-elasticsearch[count.index].rendered
}

resource "hcloud_server_network" "vm_elasticsearch_network" {
  count      = var.server_type_elasticsearch != null ? 1 : 0
  server_id  = hcloud_server.vm-elasticsearch[count.index].id
  network_id = var.network_id
}

