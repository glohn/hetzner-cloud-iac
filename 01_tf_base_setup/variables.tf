variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "Location of the Load Balancer"
  type        = string
}

variable "cidr_block" {
  description = "CIDR of the private network"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of the Load Balancer"
  type        = string
}

