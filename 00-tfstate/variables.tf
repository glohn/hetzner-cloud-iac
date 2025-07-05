variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
}

variable "hcloud_dns_token" {
  description = "API token for access to Hetzner DNS"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name (e.g., your name or organization)"
  type        = string
}

variable "location" {
  description = "Hetzner location, e.g. nbg1, fsn1 or hel1"
  type        = string
}

variable "minio_domain" {
  description = "Domain suffix for the MinIO (S3-compatible) server"
  type        = string
}

variable "s3_access_key" {
  description = "Access key for the S3-compatible storage"
  type        = string
}

variable "s3_secret_key" {
  description = "Secret key for the S3-compatible storage"
  type        = string
}

variable "rabbitmq_admin_password" {
  description = "RabbitMQ admin password (username will be project name)"
  type        = string
  sensitive   = true
}

variable "rds_root_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "rds_app_password" {
  description = "RDS application password (username will be project name)"
  type        = string
  sensitive   = true
}

