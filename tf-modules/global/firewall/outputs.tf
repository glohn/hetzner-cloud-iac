output "firewall_id_vm_ssh" {
  description = "The ID of the SSH firewall for vms"
  value       = hcloud_firewall.fw-vm-ssh.id
}

output "firewall_id_services_ssh" {
  description = "The ID of the SSH firewall for services"
  value       = hcloud_firewall.fw-services-ssh.id
}

output "firewall_id_elasticsearch" {
  description = "The ID of the Elasticsearch firewall"
  value       = hcloud_firewall.fw-elasticsearch.id
}

output "firewall_id_rabbitmq" {
  description = "The ID of the RabbitMQ firewall"
  value       = hcloud_firewall.fw-rabbitmq.id
}

output "firewall_id_rds" {
  description = "The ID of the RDS firewall"
  value       = hcloud_firewall.fw-rds.id
}

output "firewall_id_redis" {
  description = "The ID of the Redis firewall"
  value       = hcloud_firewall.fw-redis.id
}

