variable "public_key" {
  description = "SSH public key"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "volume_size" {
  description = "Size of additional volume on server"
  type        = number
}


