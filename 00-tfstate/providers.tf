terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 3.3.0"
    }
  }
}

provider "minio" {
  minio_server   = var.minio_domain
  minio_user     = var.s3_access_key
  minio_password = var.s3_secret_key
  minio_region   = "nbg1"
  minio_ssl      = true
}

