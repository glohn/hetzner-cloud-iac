variable "project" {
  description = "Name of the project"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "List of IPs allowed to access SSH"
  type        = list(string)
}

variable "load_balancer_ipv4" {
  description = "IPv4 of the load balancer"
  type        = string
}

