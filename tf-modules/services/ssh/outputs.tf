output "ssh_key_ids" {
  description = "IDs of ssh keys"
  value       = { for key, ssh_key in hcloud_ssh_key.ssh_keys : key => ssh_key.id }
}

output "ansible_public_key" {
  value = hcloud_ssh_key.ansible_ssh_key.id
}

output "ansible_private_key" {
  value     = tls_private_key.ansible_ssh.private_key_openssh
  sensitive = true
}

