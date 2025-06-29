variable "project" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "Hetzner location"
  type        = string
}

variable "user_keys" {
  description = "SSH public keys of users"
  type        = map(string)
}

variable "hetzner_api_token" {
  description = "Hetzner API token for Storage Box management"
  type        = string
  sensitive   = true
}

variable "storage_box_password" {
  description = "Password for Storage Box access"
  type        = string
  sensitive   = true
}

variable "storage_box_type" {
  description = "Storage Box type (bx11, bx21, bx31, bx41)"
  type        = string
  default     = null
}

