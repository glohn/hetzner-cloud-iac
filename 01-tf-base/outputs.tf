output "ssh_key_ids" {
  description = "IDs of ssh keys"
  value       = module.ssh.ssh_key_ids
}

output "ansible_public_key" {
  description = "Public SSH key for ansible"
  value       = module.ssh.ansible_public_key
}

#output "ansible_private_key" {
#  description = "Private SSH key for ansible"
#  value       = module.ssh.ansible_private_key
#  sensitive   = true
#}

output "network_id" {
  description = "The ID of the private network"
  value       = module.vpc.network_id
}

#output "subnet_cidrs" {
#  description = "The subnet CIDR of the private network"
#  value       = module.vpc.subnet_cidrs
#}

output "managed_certificate_id" {
  description = "ID of the managed certificate"
  value       = module.certificate.managed_certificate_id
}

output "domainname" {
  description = "Domain to use for tls offloading in the load balancer"
  value       = var.domainname
}

#output "server_id_elasticsearch" {
#  description = "ID of the elasticsearch server"
#  value       = module.elasticsearch.server_id_elasticsearch
#}
#
#output "server_id_rabbitmq" {
#  description = "ID of the rabbitmq server"
#  value       = module.rabbitmq.server_id_rabbitmq
#}
#
#output "server_id_rds" {
#  description = "ID of the rds server"
#  value       = module.rds.server_id_rds
#}
#
#output "server_id_redis" {
#  description = "ID of the redis server"
#  value       = module.redis.server_id_redis
#}
#
#output "server_type_elasticsearch" {
#  description = "Hetzner server type to deploy, e.g. cx22"
#  value       = var.server_type_elasticsearch
#}
#
#output "server_type_rabbitmq" {
#  description = "Hetzner server type to deploy, e.g. cx22"
#  value       = var.server_type_rabbitmq
#}
#
#output "server_type_rds" {
#  description = "Hetzner server type to deploy, e.g. cx22"
#  value       = var.server_type_rds
#}
#
#output "server_type_redis" {
#  description = "Hetzner server type to deploy, e.g. cx22"
#  value       = var.server_type_redis
#}

output "firewall_id_ssh" {
  description = "The ID of the SSH firewall"
  value       = module.firewall.firewall_id_ssh
}

