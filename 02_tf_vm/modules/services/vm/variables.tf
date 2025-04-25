variable "projectname" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1"
  type        = string
}

variable "public_key" {
  description = "SSH public key to provision"
  type        = string
}

