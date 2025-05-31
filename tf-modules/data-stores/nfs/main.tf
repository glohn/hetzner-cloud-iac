resource "hcloud_server" "vm-nfs" {
  count = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-nfs"
  server_type = var.server_type_nfs
  image       = var.default_image
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  labels = {
    service-type = "nfs"
    environment  = var.project
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_nfs_network" {
  count      = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0
  server_id  = hcloud_server.vm-nfs[count.index].id
  network_id = var.network_id
}

resource "hcloud_volume" "vm-nfs-volume" {
  count     = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0
  name      = "${var.project}-nfs-volume"
  size      = var.volume_size_nfs
  server_id = hcloud_server.vm-nfs[0].id
  automount = false
  format    = "ext4"
}

resource "null_resource" "wait_for_ssh" {
  count = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.vm-nfs[0].ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.vm-nfs]
}

resource "null_resource" "ansible_provision" {
  count = var.server_type_nfs != null && var.volume_size_nfs >= 10 ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      echo '${var.ansible_private_key}' > /tmp/ansible_key_nfs
      chmod 600 /tmp/ansible_key_nfs

      ANSIBLE_LOG_PATH=/tmp/ansible-nfs.log SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 ANSIBLE_CONFIG=../ansible/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${hcloud_server.vm-nfs[0].ipv4_address},' \
      --private-key=/tmp/ansible_key_nfs -u root \
      --extra-vars="nfs_volume_device=${hcloud_volume.vm-nfs-volume[0].linux_device} nfs_client_network=${var.subnet_cidrs[0]}" \
      ../ansible/nfs.yml

      if SSH_AGENT_PID=0 SSH_AUTH_SOCK=0 scp -i /tmp/ansible_key_nfs -o StrictHostKeyChecking=no \
        /tmp/ansible-nfs.log root@${hcloud_server.vm-nfs[0].ipv4_address}:/var/log/ansible.log; then
        echo "Log copied successfully, cleaning up"
        rm -f /tmp/ansible-nfs.log
      else
        echo "ERROR: Log copy failed – keeping local /tmp/ansible-nfs.log"
      fi

      rm -f /tmp/ansible_key_nfs
    EOT
  }

  depends_on = [null_resource.wait_for_ssh, hcloud_volume.vm-nfs-volume]
}

