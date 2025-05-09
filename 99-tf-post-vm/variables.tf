variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "IPs which are allowed to ssh into instance"
  type        = list(string)
}

