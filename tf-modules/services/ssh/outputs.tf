output "ssh_key_ids" {
  description = "IDs of ssh keys"
  value       = { for key, ssh_key in hcloud_ssh_key.ssh_keys : key => ssh_key.id }
}

output "ansible_public_key" {
  value = tls_private_key.ansible_ssh.public_key_pem
}

output "ansible_private_key" {
  value     = tls_private_key.ansible_ssh.private_key_pem
  sensitive = true
}

