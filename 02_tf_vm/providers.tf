terraform {
  required_version = ">= 1.10"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }

  backend "s3" {
    bucket   = "yourname-hetzner-lab-tfstate"
    key      = "vm.tfstate"
    region   = "main"
    endpoint = "https://nbg1.your-objectstorage.com"

    profile                     = "hetzner-lab"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

data "terraform_remote_state" "tfstate-base" {
  backend = "s3"
  config = {
    bucket = "yourname-${var.project}-tfstate"
    key    = "base.tfstate"
    region = "main"
    endpoints = {
      s3 = "https://nbg1.your-objectstorage.com"
    }

    profile                     = "hetzner-lab"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

