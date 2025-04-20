terraform {
  required_version = ">= 1.5.7"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

terraform {
  backend "s3" {
    bucket   = "yourname-talos-lab-tfstate"
    key      = "base.tfstate"
    region   = "main"
    endpoint = "https://nbg1.your-objectstorage.com"

    profile                     = "talos-lab-s3"
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

resource "hcloud_ssh_key" "default" {
  name       = "guido@local"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_server" "test" {
  name        = "tf-test"
  server_type = "cx22"
  image       = "debian-12"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.default.id]
}

