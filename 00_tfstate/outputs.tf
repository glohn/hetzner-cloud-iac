output "project" {
  description = "Name of the project"
  value       = var.project
}

output "location" {
  description = "Hetzner location"
  value       = var.location
}

output "hcloud_token" {
  description = "Hetzner Cloud API token"
  value       = var.hcloud_token
  sensitive   = true
}

