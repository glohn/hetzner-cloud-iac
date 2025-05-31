resource "hcloud_server" "vm-rds" {
  count = var.server_type_rds != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-rds"
  server_type = var.server_type_rds
  image       = var.default_image
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  labels = {
    service-type = "rds"
    environment  = var.project
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_rds_network" {
  count      = var.server_type_rds != null ? 1 : 0
  server_id  = hcloud_server.vm-rds[count.index].id
  network_id = var.network_id
}

resource "null_resource" "wait_for_ssh" {
  count = var.server_type_rds != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.vm-rds[0].ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.vm-rds]
}

resource "null_resource" "ansible_provision" {
  count = var.server_type_rds != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      echo '${var.ansible_private_key}' > /tmp/ansible_key_rds
      chmod 600 /tmp/ansible_key_rds

      ANSIBLE_LOG_PATH=/tmp/ansible-rds.log SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 ANSIBLE_CONFIG=../ansible/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${hcloud_server.vm-rds[0].ipv4_address},' \
      --private-key=/tmp/ansible_key_rds -u root \
      --extra-vars="rds_root_password=${var.rds_root_password} rds_app_password=${var.rds_app_password} rds_database_name=${replace(var.project, "-", "_")} rds_username=${replace(var.project, "-", "_")}" \
      ../ansible/rds.yml

      if SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 scp -i /tmp/ansible_key_rds -o StrictHostKeyChecking=no \
        /tmp/ansible-rds.log root@${hcloud_server.vm-rds[0].ipv4_address}:/var/log/ansible.log; then
        echo "Log copied successfully, cleaning up"
        rm -f /tmp/ansible-rds.log
      else
        echo "ERROR: Log copy failed – keeping local /tmp/ansible-rds.log"
      fi

      rm -f /tmp/ansible_key_rds
    EOT
  }

  depends_on = [null_resource.wait_for_ssh]
}

