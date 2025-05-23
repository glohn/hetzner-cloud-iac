variable "firewall_id_services_ssh" {
  description = "The ID of the ssh firewall rule for services"
  type        = string
}

variable "server_type_elasticearch" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_rabbitmq" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_rds" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_type_redis" {
  description = "Hetzner server type to deploy, e.g. cx22"
  type        = string
}

variable "server_id_elasticsearch" {
  description = "IDs of the servers"
  type        = list(string)
  default     = []
}

variable "server_id_rabbitmq" {
  description = "IDs of the servers"
  type        = list(string)
  default     = []
}

variable "server_id_rds" {
  description = "IDs of the servers"
  type        = list(string)
  default     = []
}

variable "server_id_redis" {
  description = "IDs of the servers"
  type        = list(string)
  default     = []
}

