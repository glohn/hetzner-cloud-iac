output "firewall_id_ssh" {
  description = "The ID of the SSH firewall"
  value       = hcloud_firewall.fw-ssh.id
}

