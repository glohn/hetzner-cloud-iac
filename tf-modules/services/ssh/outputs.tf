output "ssh_key_ids" {
  description = "IDs of ssh keys"
  value       = { for key, ssh_key in hcloud_ssh_key.ssh_keys : key => ssh_key.id }
}

