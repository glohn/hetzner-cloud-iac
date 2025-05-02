variable "project" {
  description = "Name of the project"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "List of IPs allowed to access SSH"
  type        = list(string)
}

variable "load_balancer_ipv4" {
  description = "IPv4 of the load balancer"
  type        = string
}

variable "source_ips" {
  description = "IPv4 of the provisioned instances"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_port" {
  description = "Port for ssh service"
  type        = string
  default     = "22"
}

variable "elastic_port" {
  description = "Port for elasticsearch service"
  type        = string
  default     = "9200"
}

variable "http_port" {
  description = "Port for http service"
  type        = string
  default     = "80"
}

variable "rds_port" {
  description = "Port for rds service"
  type        = string
  default     = "3306"
}

variable "redis_port" {
  description = "Port for redis service"
  type        = string
  default     = "6379"
}

