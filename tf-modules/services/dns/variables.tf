variable "project" {
  description = "Name of the project"
  type        = string
}

variable "domainname" {
  description = "The domain for which to create the certificate"
  type        = string
}

variable "load_balancer_sw_web_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
  default     = ""
}

variable "load_balancer_sw_admin_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
  default     = ""
}

variable "load_balancer_pim_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
  default     = ""
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

