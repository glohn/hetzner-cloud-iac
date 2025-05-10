output "ssh_key_ids" {
  description = "IDs of ssh keys"
  value       = module.ssh.ssh_key_ids
}

output "network_id" {
  description = "The ID of the private network"
  value       = module.vpc.network_id
}

output "subnet_cidrs" {
  description = "The subnet CIDR of the private network"
  value       = module.vpc.subnet_cidrs
}

output "managed_certificate_id" {
  description = "ID of the managed certificate"
  value       = module.certificate.managed_certificate_id
}

output "domainname" {
  description = "Domain to use for tls offloading in the load balancer"
  value       = var.domainname
}

