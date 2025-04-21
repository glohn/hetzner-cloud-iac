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

resource "null_resource" "wait_for_rescue_ready" {
  provisioner "local-exec" {
    command = <<-EOT
      IP="${hcloud_server.test.ipv4_address}"
      while ! (nc -z "$IP" 22 && ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 root@$IP 'uname -a | grep -qi rescue' 2>/dev/null); do
        sleep 2
      done
    EOT
  }

  depends_on = [null_resource.reboot_into_rescue]
}

resource "null_resource" "download_talos_iso" {
  provisioner "local-exec" {
    command = <<-EOT
      ssh-keygen -R ${hcloud_server.test.ipv4_address} || true
      ssh -o StrictHostKeyChecking=no root@${hcloud_server.test.ipv4_address} '
        set -e

        VERSION="v${var.talos_version}"
        URL="https://github.com/siderolabs/talos/releases/download/$VERSION/metal-amd64.iso"
        OUT="/tmp/metal-amd64.iso"
        TMP="/tmp/metal-amd64.iso.tmp"

        echo "Downloading Talos ISO $VERSION..."
        curl -L -o "$TMP" "$URL"
        mv "$TMP" "$OUT"
        echo "Download complete."
      '
    EOT
  }

  depends_on = [null_resource.wait_for_rescue_ready]
}

resource "null_resource" "write_iso_to_disk" {
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no root@${hcloud_server.test.ipv4_address} '
        set -euo pipefail

        ISO="/tmp/metal-amd64.iso"
        DEVICE="/dev/sda"

        echo "Writing ISO to disk..."
        dd if="$ISO" of="$DEVICE" bs=4M status=progress oflag=direct

        sync
        echo "ISO written successfully."
      '
    EOT
  }

  depends_on = [null_resource.download_talos_iso]
}

resource "null_resource" "reboot_into_talos" {
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no root@${hcloud_server.test.ipv4_address} '
        echo "Rebooting into Talos..."
        reboot
      '
    EOT
  }

  depends_on = [null_resource.write_iso_to_disk]
}

