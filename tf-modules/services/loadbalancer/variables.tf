variable "project" {
  description = "Name of the project"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of the load Balancer"
  type        = string
}

variable "load_balancer_location" {
  description = "Location of the load Balancer"
  type        = string
}

variable "network_id" {
  description = "The ID of the private network"
  type        = string
}

variable "managed_certificate" {
  description = "ID of the managed certificate"
  type        = string
}

variable "server_type_sw_web" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_sw_admin" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_pim" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "number_instances_sw_web" {
  description = "Number of Shopware webserver"
  type        = number
  default     = 0
}

variable "server_ids_sw_web" {
  description = "IDs of the Shopware web servers (needed for load balancer targets)"
  type        = list(string)
  default     = null
}

variable "server_id_sw_admin" {
  description = "ID of the Shopware adminserver (needed for load balancer targets)"
  type        = list(string)
  default     = null
}

variable "server_id_pim" {
  description = "ID of the pimcore server (needed for load balancer targets)"
  type        = list(string)
  default     = null
}

variable "http_port" {
  description = "Port for http service"
  type        = string
  default     = "80"
}

