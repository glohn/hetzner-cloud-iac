variable "projectname" {
  description = "Name of the project"
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

