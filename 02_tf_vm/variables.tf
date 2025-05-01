variable "user_keys" {
  description = "A map of usernames to their public keys"
  type        = map(string)
}

variable "server_type" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "volume_size" {
  description = "Size of additional volume on server"
  type        = number
}


