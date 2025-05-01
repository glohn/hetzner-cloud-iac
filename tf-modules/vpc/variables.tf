variable "project" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "Location of the network"
  type        = string
}

variable "cidr_block" {
  description = "CIDR for the private network"
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 1
}

