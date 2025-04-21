resource "null_resource" "wait_for_ssh" {
  provisioner "local-exec" {
    command = <<-EOT
      while ! nc -z ${var.server_ip} 22; do
        sleep 2
      done
    EOT
  }
}

resource "null_resource" "enable_rescue" {
  provisioner "local-exec" {
    command = <<-EOT
      ACTION_ID=$(curl -s -X POST \
        -H "Authorization: Bearer ${var.hcloud_token}" \
        -H "Content-Type: application/json" \
        -d '{"type": "linux64", "ssh_keys": [${var.ssh_key_id}]}' \
        "https://api.hetzner.cloud/v1/servers/${var.server_id}/actions/enable_rescue" | jq -r '.action.id')

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
      curl -s -X POST \
        -H "Authorization: Bearer ${var.hcloud_token}" \
        "https://api.hetzner.cloud/v1/servers/${var.server_id}/actions/reboot"
    EOT
  }

  depends_on = [null_resource.enable_rescue]
}

resource "null_resource" "wait_for_rescue_ready" {
  provisioner "local-exec" {
    command = <<-EOT
      IP="${var.server_ip}"
      while ! (nc -z "$IP" 22 && ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 root@$IP 'uname -a | grep -qi rescue' 2>/dev/null); do
        sleep 2
      done
    EOT
  }

  depends_on = [null_resource.reboot_into_rescue]
}

