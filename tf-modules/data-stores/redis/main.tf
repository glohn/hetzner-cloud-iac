resource "hcloud_server" "vm-redis" {
  count = var.server_type_redis != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-redis"
  server_type = var.server_type_redis
  image       = "debian-12"
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_redis_network" {
  count      = var.server_type_redis != null ? 1 : 0
  server_id  = hcloud_server.vm-redis[count.index].id
  network_id = var.network_id
}

resource "null_resource" "wait_for_ssh" {
  count = var.server_type_redis != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.vm-redis[0].ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.vm-redis]
}

resource "null_resource" "ansible_provision" {
  count = var.server_type_redis != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      echo '${var.ansible_private_key}' > /tmp/ansible_key
      chmod 600 /tmp/ansible_key

      SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 ANSIBLE_CONFIG=../ansible/playbooks/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${hcloud_server.vm-redis[0].ipv4_address},' \
      --private-key=/tmp/ansible_key -u root \
      --extra-vars="redis_bind_ip=${hcloud_server_network.vm_redis_network[0].ip}" \
      ../ansible/playbooks/install_redis.yml

      if SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 scp -i /tmp/ansible_key -o StrictHostKeyChecking=no \
        /tmp/ansible.log root@${hcloud_server.vm-redis[0].ipv4_address}:/var/log/ansible.log; then
        echo "Log copied successfully, cleaning up"
        rm -f /tmp/ansible.log
      else
        echo "ERROR: Log copy failed – keeping local /tmp/ansible.log"
      fi

      rm -f /tmp/ansible_key
    EOT
  }

  depends_on = [null_resource.wait_for_ssh]
}

