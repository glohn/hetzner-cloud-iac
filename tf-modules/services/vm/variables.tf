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

variable "user_keys" {
  description = "SSH public keys of users"
  type        = map(string)
}

variable "network_id" {
  description = "The ID of the private network"
  type        = string
}

#variable "load_balancer_id" {
#  description = "The ID of the load balancer"
#  type        = string
#}

#variable "domainname" {
#  description = "Domain to use for tls offloading in the load balancer"
#  type        = string
#}

#variable "managed_certificate" {
#  description = "ID of the managed certificate"
#  type        = string
#}

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

