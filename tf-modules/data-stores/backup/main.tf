# Local variables
locals {
  storage_box_name = "${var.project}-backup"
  ssh_keys_json    = length(var.user_keys) > 0 ? jsonencode(values(var.user_keys)) : "[]"
}

# Create Storage Box via API
resource "null_resource" "storage_box" {
  count = var.storage_box_type != null ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      # Check if Storage Box already exists by name
      EXISTING_ID=$(curl -s \
        -H "Authorization: Bearer ${var.hetzner_api_token}" \
        "https://api.hetzner.com/v1/storage_boxes?name=${local.storage_box_name}" \
        | jq -r '.storage_boxes[0].id // empty')

      if [ -n "$EXISTING_ID" ] && [ "$EXISTING_ID" != "null" ]; then
        echo "Storage Box '${local.storage_box_name}' already exists with ID: $EXISTING_ID"
      else
        echo "Creating new Storage Box: ${local.storage_box_name}"

        # Create new Storage Box
        RESPONSE=$(curl -s \
          -X POST \
          -H "Authorization: Bearer ${var.hetzner_api_token}" \
          -H "Content-Type: application/json" \
          -d '{
            "storage_box_type": "${var.storage_box_type}",
            "location": "${var.location}",
            "name": "${local.storage_box_name}",
            "password": "${var.storage_box_password}",
            "ssh_keys": ${local.ssh_keys_json},
            "access_settings": {
              "ssh_enabled": true,
              "reachable_externally": true
            }
          }' \
          "https://api.hetzner.com/v1/storage_boxes")

        # Check if creation was successful
        if echo "$RESPONSE" | jq -e '.action.id' > /dev/null; then
          ACTION_ID=$(echo "$RESPONSE" | jq -r '.action.id')
          STORAGE_BOX_ID=$(echo "$RESPONSE" | jq -r '.action.resources[] | select(.type=="storage_box") | .id')
          echo "Storage Box created successfully. Action ID: $ACTION_ID, Storage Box ID: $STORAGE_BOX_ID"
        else
          echo "Error creating Storage Box:"
          echo "$RESPONSE" | jq '.'
          exit 1
        fi
      fi
    EOT

    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -e

      # Find Storage Box by name and delete it
      STORAGE_BOX_ID=$(curl -s \
        -H "Authorization: Bearer ${var.hetzner_api_token}" \
        "https://api.hetzner.com/v1/storage_boxes?name=${local.storage_box_name}" \
        | jq -r '.storage_boxes[0].id // empty')

      if [ -n "$STORAGE_BOX_ID" ] && [ "$STORAGE_BOX_ID" != "null" ]; then
        echo "Deleting Storage Box '${local.storage_box_name}' with ID: $STORAGE_BOX_ID"

        curl -s \
          -X DELETE \
          -H "Authorization: Bearer ${var.hetzner_api_token}" \
          "https://api.hetzner.com/v1/storage_boxes/$STORAGE_BOX_ID" || true
      else
        echo "Storage Box '${local.storage_box_name}' not found - nothing to delete"
      fi
    EOT

    interpreter = ["bash", "-c"]
  }
}

# Get Storage Box information for outputs
data "external" "storage_box_info" {
  count = var.storage_box_type != null ? 1 : 0

  program = ["bash", "-c", <<-EOT
    curl -s -H "Authorization: Bearer ${var.hetzner_api_token}" \
      "https://api.hetzner.com/v1/storage_boxes?name=${local.storage_box_name}" \
      | jq -r '.storage_boxes[0] | {id: (.id | tostring)}'
  EOT
  ]

  depends_on = [null_resource.storage_box]
}

