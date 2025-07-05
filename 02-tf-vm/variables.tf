variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
}

variable "server_type_bastion" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
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

