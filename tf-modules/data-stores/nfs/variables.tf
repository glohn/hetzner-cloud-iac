variable "project" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1"
  type        = string
}

variable "ssh_key_ids" {
  description = "IDs of ssh keys"
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

variable "firewall_id_nfs" {
  description = "The ID of the nfs firewall rule"
  type        = string
}

variable "server_type_nfs" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "default_image" {
  description = "Default OS image to use for VMs"
  type        = string
}

variable "volume_size_nfs" {
  description = "Volume size in GB for NFS shares"
  type        = number

  validation {
    condition     = var.volume_size_nfs >= 10 && var.volume_size_nfs <= 10240
    error_message = "Volume size for NFS must be between 10 GB and 10 TB (10240 GB) as per Hetzner Cloud limits. Set server_type_nfs to null if you don't want to create an NFS server."
  }
}

