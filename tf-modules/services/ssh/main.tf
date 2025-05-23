resource "hcloud_ssh_key" "ssh_keys" {
  for_each   = var.user_keys
  name       = each.key
  public_key = each.value
}

resource "tls_private_key" "ansible_ssh" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "ansible_ssh_key" {
  name       = "ansible_ssh_key"
  public_key = "${tls_private_key.ansible_ssh.public_key_openssh} Ansible Key"
}

