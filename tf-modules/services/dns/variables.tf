variable "project" {
  description = "Name of the project"
  type        = string
}

variable "domainname" {
  description = "The domain for which to create the certificate"
  type        = string
}

variable "load_balancer_ipv4" {
  description = "The IPv4 of the load balancer"
  type        = string
}

