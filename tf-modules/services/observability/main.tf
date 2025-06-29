resource "hcloud_server" "vm-observability" {
  count = var.server_type_observability != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-observability"
  server_type = var.server_type_observability
  image       = var.default_image
  location    = var.location
  ssh_keys    = [var.ansible_public_key_id]
  backups     = true

  labels = {
    service-type = "observability"
    environment  = var.project
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_observability_network" {
  count      = var.server_type_observability != null ? 1 : 0
  server_id  = hcloud_server.vm-observability[count.index].id
  network_id = var.network_id
}

resource "null_resource" "wait_for_ssh" {
  count = var.server_type_observability != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.vm-observability[0].ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.vm-observability]
}

resource "null_resource" "ansible_provision" {
  count = var.server_type_observability != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      echo '${var.ansible_private_key}' > /tmp/ansible_key_observability
      chmod 600 /tmp/ansible_key_observability

      USER_SSH_KEYS_B64=$(echo '${jsonencode(var.user_keys)}' | base64 -w 0)

      ANSIBLE_LOG_PATH=/tmp/ansible-observability.log SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 ANSIBLE_CONFIG=../ansible/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${hcloud_server.vm-observability[0].ipv4_address},' \
      --private-key=/tmp/ansible_key_observability -u root \
      --extra-vars="observability_bind_ip=${hcloud_server_network.vm_observability_network[0].ip} user_ssh_keys_b64=$USER_SSH_KEYS_B64" \
      ../ansible/observability.yml

      if SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 scp -i /tmp/ansible_key_observability -o StrictHostKeyChecking=no \
        /tmp/ansible-observability.log root@${hcloud_server.vm-observability[0].ipv4_address}:/var/log/ansible.log; then
        echo "Log copied successfully, cleaning up"
        rm -f /tmp/ansible-observability.log
      else
        echo "ERROR: Log copy failed – keeping local /tmp/ansible-observability.log"
      fi

      rm -f /tmp/ansible_key_observability
    EOT
  }

  depends_on = [null_resource.wait_for_ssh]
} 