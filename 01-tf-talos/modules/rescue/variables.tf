variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
}

variable "server_ip" {
  description = "Public IP of the server"
  type        = string
}

variable "server_id" {
  description = "Hetzner server ID"
  type        = string
}

variable "ssh_key_id" {
  description = "ID of the uploaded SSH key"
  type        = string
}

