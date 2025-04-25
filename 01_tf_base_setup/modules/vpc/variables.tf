variable "project" {
  description = "Name of the project"
}

variable "location" {
  description = "Location of the network"
}

variable "cidr_block" {
  description = "CIDR for the private network"
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 1
}

