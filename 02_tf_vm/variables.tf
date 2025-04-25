variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project" {
  description = "Name of the project"
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

