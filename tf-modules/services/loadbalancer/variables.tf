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

variable "domainname" {
  description = "Domain to use for tls offloading in the load balancer"
  type        = string
}

variable "network_id" {
  description = "The ID of the private network"
  type        = string
}

variable "subnet_ip_range" {
  description = "The IP ranges of the private subnets"
  type        = list(string)
}

variable "managed_certificate" {
  description = "ID of the managed certificate"
  type        = string
}

