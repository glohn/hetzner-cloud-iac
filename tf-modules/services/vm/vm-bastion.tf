#data "template_file" "user-data-bastion" {
#  template = file("${path.module}/templates/bastion_ssh_key.tpl")
#
#  vars = {
#    ansible_private_key = tls_private_key.ansible-provisioning-key.private_key_pem
#  }
#}

resource "hcloud_server" "vm-bastion" {
  count = var.server_type_bastion != null ? 1 : 0

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-bastion"
  server_type = var.server_type_bastion
  image       = "debian-12"
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server_network" "vm_bastion_network" {
  count      = var.server_type_bastion != null ? 1 : 0
  server_id  = hcloud_server.vm-bastion[count.index].id
  network_id = var.network_id
}

