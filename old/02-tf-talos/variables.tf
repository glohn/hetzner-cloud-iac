variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "talos_version" {
  description = "Talos version to install (e.g. 1.9.5)"
  type        = string
}

