variable "project" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1"
  type        = string
}

variable "volume_size" {
  description = "Size of additional volume on server"
  type        = number
}

variable "server_type" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "user_keys" {
  description = "SSH public keys of users"
  type        = map(string)
}

variable "network_id" {
  description = "The ID of the private network"
  type        = string
}

variable "firewall_ids" {
  description = "Firewall to use for instance"
  type        = string
}

variable "load_balancer_id" {
  description = "The ID of the load balancer"
  type        = string
}

