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

variable "firewall_id_ssh" {
  description = "The ID of the ssh firewall rule"
  type        = string
}

variable "firewall_id_elasticsearch" {
  description = "The ID of the elasticsearch firewall rule"
  type        = string
}

variable "server_type_elasticsearch" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

