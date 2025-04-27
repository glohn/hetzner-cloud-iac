terraform {
  required_version = ">= 1.10"

  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 3.3.0"
    }
  }

  # The backend configuration should initially be commented out.
  # Uncomment and run 'terraform init' to migrate the local state to the S3 bucket.
  # This should be done only after the code has been run successfully once.
  #backend "s3" {
  #  bucket = "yourname-hetzner-lab-tfstate"
  #  key    = "tfstate.tfstate"
  #  region = "main"
  #  endpoints = {
  #    s3 = "https://nbg1.your-objectstorage.com"
  #  }

  #  profile                     = "hetzner-s3-tfstate"
  #  skip_credentials_validation = true
  #  skip_metadata_api_check     = true
  #  skip_region_validation      = true
  #  skip_requesting_account_id  = true
  #  skip_s3_checksum            = true
  #  use_path_style              = true
  #}

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "minio" {
  minio_server   = "${var.location}.${var.minio_domain}"
  minio_user     = var.s3_access_key
  minio_password = var.s3_secret_key
  minio_region   = var.location
  minio_ssl      = true
}

