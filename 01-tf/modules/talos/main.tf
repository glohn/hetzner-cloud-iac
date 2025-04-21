resource "null_resource" "download_talos_iso" {
  provisioner "local-exec" {
    command = <<-EOT
      ssh-keygen -R ${var.server_ip} || true
      ssh -o StrictHostKeyChecking=no root@${var.server_ip} '
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
}

resource "null_resource" "write_iso_to_disk" {
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no root@${var.server_ip} '
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
      ssh -o StrictHostKeyChecking=no root@${var.server_ip} '
        echo "Rebooting into Talos..."
        reboot
      '
    EOT
  }

  depends_on = [null_resource.write_iso_to_disk]
}

