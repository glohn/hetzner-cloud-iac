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
}

variable "load_balancer_sw_admin_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
}

variable "load_balancer_pim_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
}

