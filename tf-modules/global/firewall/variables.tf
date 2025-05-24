variable "project" {
  description = "Name of the project"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDRs of the private subnets"
  type        = list(string)
}

variable "allowed_ssh_ips" {
  description = "List of IPs allowed to access SSH"
  type        = list(string)
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

variable "elastic_dashboard_port" {
  description = "Port for elasticsearch dashboard"
  type        = string
  default     = "5601"
}

variable "http_port" {
  description = "Port for http service"
  type        = string
  default     = "80"
}

variable "rabbitmq_port" {
  description = "Port for rabbitmq service"
  type        = string
  default     = "5672"
}

variable "rabbitmq_mgmt_port" {
  description = "Port for rabbitmq management ui"
  type        = string
  default     = "15672"
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

