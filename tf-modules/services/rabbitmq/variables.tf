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

variable "firewall_id_rabbitmq" {
  description = "The ID of the RabbitMQ firewall rule"
  type        = string
}

variable "server_type_rabbitmq" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "default_image" {
  description = "Default OS image to use for VMs"
  type        = string
}

variable "rabbitmq_admin_password" {
  description = "Password for RabbitMQ admin user"
  type        = string
  sensitive   = true
}

