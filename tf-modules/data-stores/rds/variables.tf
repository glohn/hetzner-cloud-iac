variable "project" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1"
  type        = string
}

variable "user_keys" {
  description = "SSH public keys of users to be managed by Ansible"
  type        = map(string)
}

variable "ansible_public_key_id" {
  description = "ID of the public SSH key for Ansible access"
  type        = string
}

variable "ansible_private_key" {
  description = "Private SSH key for Ansible access"
  type        = string
}

variable "network_id" {
  description = "The ID of the private network"
  type        = string
}

variable "firewall_id_rds" {
  description = "The ID of the rds firewall rule"
  type        = string
}

variable "server_type_rds" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "default_image" {
  description = "Default OS image to use for VMs"
  type        = string
}

variable "volume_size_rds" {
  description = "Volume size in GB for database data"
  type        = number

  validation {
    condition     = var.volume_size_rds >= 10 && var.volume_size_rds <= 10240
    error_message = "Volume size for RDS must be between 10 GB and 10 TB (10240 GB) as per Hetzner Cloud limits. Set server_type_rds to null if you don't want to create an RDS server."
  }
}

variable "rds_root_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "rds_app_password" {
  description = "RDS application password (username will be project name)"
  type        = string
  sensitive   = true
}

