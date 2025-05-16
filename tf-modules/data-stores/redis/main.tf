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
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key])
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_net[0].ipv4_ip},' --private-key=${var.ansible_private_key} -u root ../ansible/playbooks/install_redis.yml"
  }
}

resource "hcloud_server_network" "vm_redis_network" {
  count      = var.server_type_redis != null ? 1 : 0
  server_id  = hcloud_server.vm-redis[count.index].id
  network_id = var.network_id
}

