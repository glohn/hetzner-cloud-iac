variable "cidr_block" {
  description = "CIDR of the private network"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
}

variable "domainname" {
  description = "Domain to use for tls offloading in the load balancer"
  type        = string
}

