terraform {
  required_version = ">= 1.10"

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
  public_key = var.public_key
}

resource "hcloud_server" "test" {
  name        = var.servername
  server_type = var.server_type
  image       = "debian-12"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
}

resource "null_resource" "wait_for_ssh" {
  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${hcloud_server.test.ipv4_address} 22; do
        sleep 2
      done
    EOT
  }

  depends_on = [hcloud_server.test]
}

resource "null_resource" "enable_rescue" {
  provisioner "local-exec" {
    command = <<-EOT
      ACTION_ID=$(curl -s -X POST \
        -H "Authorization: Bearer ${var.hcloud_token}" \
        -H "Content-Type: application/json" \
        -d '{"type": "linux64", "ssh_keys": [${hcloud_ssh_key.default.id}]}' \
        "https://api.hetzner.cloud/v1/servers/${hcloud_server.test.id}/actions/enable_rescue" | jq -r '.action.id')

      while true; do
        STATUS=$(curl -s \
          -H "Authorization: Bearer ${var.hcloud_token}" \
          "https://api.hetzner.cloud/v1/actions/$ACTION_ID" | jq -r '.action.status')
        [ "$STATUS" = "success" ] && break
        sleep 2
      done
    EOT
  }

  depends_on = [null_resource.wait_for_ssh]
}

resource "null_resource" "reboot_into_rescue" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep 10
      curl -s -X POST \
        -H "Authorization: Bearer ${var.hcloud_token}" \
        "https://api.hetzner.cloud/v1/servers/${hcloud_server.test.id}/actions/reboot"
    EOT
  }

  depends_on = [null_resource.enable_rescue]
}

