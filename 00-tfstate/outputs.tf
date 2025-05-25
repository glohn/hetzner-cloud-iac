output "project" {
  description = "Name of the project"
  value       = var.project
}

output "location" {
  description = "Hetzner location"
  value       = var.location
}

output "hcloud_token" {
  description = "Hetzner Cloud API token for project"
  value       = var.hcloud_token
  sensitive   = true
}

output "hcloud_dns_token" {
  description = "API token for access to Hetzner DNS"
  value       = var.hcloud_dns_token
  sensitive   = true
}

output "rabbitmq_admin_password" {
  description = "RabbitMQ admin password"
  value       = var.rabbitmq_admin_password
  sensitive   = true
}

output "rds_root_password" {
  description = "RDS root password"
  value       = var.rds_root_password
  sensitive   = true
}

output "rds_app_password" {
  description = "RDS application password"
  value       = var.rds_app_password
  sensitive   = true
}

