variable "user_keys" {
  description = "A map of usernames to their public keys"
  type        = map(string)
}

variable "server_type_sw_web" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_sw_admin" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_pim" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_rds" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_elasticsearch" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_rabbitmq" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "server_type_redis" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
  default     = null
}

variable "number_instances_sw_web" {
  description = "Number of Shopware webserver"
  type        = number
  default     = 0
}

variable "allowed_ssh_ips" {
  description = "IPs which are allowed to ssh into instance"
  type        = list(string)
}

variable "volume_size" {
  description = "Size of additional volume"
  type        = number
  default     = 0
}

