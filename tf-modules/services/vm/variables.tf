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

variable "network_id" {
  description = "The ID of the private network"
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

