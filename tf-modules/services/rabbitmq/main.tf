resource "hcloud_server" "vm-rabbitmq" {
  count = var.server_type_rabbitmq != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-rabbitmq"
  server_type = var.server_type_rabbitmq
  image       = var.default_image
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  labels = {
    service-type = "rabbitmq"
    environment  = var.project
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_rabbitmq_network" {
  count      = var.server_type_rabbitmq != null ? 1 : 0
  server_id  = hcloud_server.vm-rabbitmq[count.index].id
  network_id = var.network_id
}

resource "null_resource" "wait_for_ssh" {
  count = var.server_type_rabbitmq != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.vm-rabbitmq[0].ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.vm-rabbitmq]
}

resource "null_resource" "ansible_provision" {
  count = var.server_type_rabbitmq != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      echo '${var.ansible_private_key}' > /tmp/ansible_key_rabbitmq
      chmod 600 /tmp/ansible_key_rabbitmq

      ANSIBLE_LOG_PATH=/tmp/ansible-rabbitmq.log SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 ANSIBLE_CONFIG=../ansible/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${hcloud_server.vm-rabbitmq[0].ipv4_address},' \
      --private-key=/tmp/ansible_key_rabbitmq -u root \
      --extra-vars="rabbitmq_bind_ip=${hcloud_server_network.vm_rabbitmq_network[0].ip} rabbitmq_admin_user=${var.project} rabbitmq_admin_password=${var.rabbitmq_admin_password}" \
      ../ansible/rabbitmq.yml

      if SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 scp -i /tmp/ansible_key_rabbitmq -o StrictHostKeyChecking=no \
        /tmp/ansible-rabbitmq.log root@${hcloud_server.vm-rabbitmq[0].ipv4_address}:/var/log/ansible.log; then
        echo "Log copied successfully, cleaning up"
        rm -f /tmp/ansible-rabbitmq.log
      else
        echo "ERROR: Log copy failed – keeping local /tmp/ansible-rabbitmq.log"
      fi

      rm -f /tmp/ansible_key_rabbitmq
    EOT
  }

  depends_on = [null_resource.wait_for_ssh]
}

