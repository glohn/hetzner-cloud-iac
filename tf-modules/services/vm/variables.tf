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
  description = "ID of the public SSH key for ansible"
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

variable "server_type_bastion" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_sw_web" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_sw_admin" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_pim" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "number_instances_sw_web" {
  description = "Number of shopware webserver"
  type        = number
}

variable "default_image" {
  description = "Default OS image to use for VMs"
  type        = string
}

