terraform {
  required_version = ">= 1.10"

  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }

  backend "s3" {
    bucket   = "yourname-test-lab-tfstate"
    key      = "vm-post.tfstate"
    region   = "main"
    endpoint = "https://nbg1.your-objectstorage.com"

    profile                     = "hetzner-s3-tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

data "terraform_remote_state" "tfstate-tfstate" {
  backend = "s3"
  config = {
    bucket = "yourname-test-lab-tfstate"
    key    = "tfstate.tfstate"
    region = "main"
    endpoints = {
      s3 = "https://nbg1.your-objectstorage.com"
    }

    profile                     = "hetzner-s3-tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

data "terraform_remote_state" "tfstate-base" {
  backend = "s3"
  config = {
    bucket = "yourname-test-lab-tfstate"
    key    = "base.tfstate"
    region = "main"
    endpoints = {
      s3 = "https://nbg1.your-objectstorage.com"
    }

    profile                     = "hetzner-s3-tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

data "terraform_remote_state" "tfstate-vm" {
  backend = "s3"
  config = {
    bucket = "yourname-test-lab-tfstate"
    key    = "vm.tfstate"
    region = "main"
    endpoints = {
      s3 = "https://nbg1.your-objectstorage.com"
    }

    profile                     = "hetzner-s3-tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "hcloud" {
  token = data.terraform_remote_state.tfstate-tfstate.outputs.hcloud_token
}

