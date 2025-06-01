output "ssh_key_ids" {
  description = "IDs of ssh keys registered with Hetzner"
  value       = { for key, ssh_key in hcloud_ssh_key.ssh_keys : key => ssh_key.id }
}

output "ansible_public_key" {
  description = "ID of the Ansible public key registered with Hetzner"
  value       = hcloud_ssh_key.ansible_ssh_key.id
}

output "ansible_private_key" {
  description = "Private key for Ansible SSH authentication"
  value       = tls_private_key.ansible_ssh.private_key_openssh
  sensitive   = true
}

