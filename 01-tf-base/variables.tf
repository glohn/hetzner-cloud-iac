variable "cidr_block" {
  description = "CIDR of the private network"
  type        = string
}

variable "domainname" {
  description = "Domain to use for tls offloading in the load balancer"
  type        = string
}

variable "user_keys" {
  description = "A map of usernames to their public keys"
  type        = map(string)
}

variable "allowed_ssh_ips" {
  description = "IPs which are allowed to ssh into instance"
  type        = list(string)
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

variable "server_type_nfs" {
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

variable "volume_size_nfs" {
  description = "Size in GB of additional volume"
  type        = number
  default     = 0
}

variable "volume_size_rds" {
  description = "Size in GB of database volume"
  type        = number
  default     = 0
}

variable "default_image" {
  description = "Default OS image to use for all VMs"
  type        = string
}

