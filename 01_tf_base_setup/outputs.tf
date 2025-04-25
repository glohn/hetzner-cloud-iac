output "network_id" {
  description = "The ID of the private network"
  value       = module.vpc.network_id
}

output "subnet_id" {
  description = "The subnet ID of the private network"
  value       = module.vpc.subnet_ids
}

