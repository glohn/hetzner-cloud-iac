locals {
  # Check if any servers should be created based on input variables
  create_servers = var.number_instances_sw_web > 0 || var.server_type_sw_admin != null || var.server_type_pim != null || var.server_type_bastion != null
}

resource "hcloud_firewall_attachment" "fw-vm-ssh" {
  count          = local.create_servers ? 1 : 0
  firewall_id    = var.firewall_id_ssh
  label_selectors = ["service-type=vm"]
}

