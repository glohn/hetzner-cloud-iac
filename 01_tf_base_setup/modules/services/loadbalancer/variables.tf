variable "project" {
  description = "Name of the project"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
}

variable "load_balancer_location" {
  description = "Location of the Load Balancer"
  type        = string
}

variable "network_id" {
  description = "The ID of the private network"
}

variable "subnet_ip_range" {
  description = "The IP ranges of the private subnets"
}

