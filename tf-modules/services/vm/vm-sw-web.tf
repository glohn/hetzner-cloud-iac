data "cloudinit_config" "user-data-sw-web" {
  for_each = var.server_type_sw_web != null ? {
    for i in range(var.number_instances_sw_web) : "vm_sw_web_${i}" => i
  } : {}

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/scripts/install_docker.sh")
  }
}

resource "hcloud_server" "vm-sw-web" {
  for_each = var.server_type_sw_web != null ? {
    for i in range(var.number_instances_sw_web) : "vm_sw_web_${i}" => i
  } : {}

  lifecycle {
    ignore_changes = [
      user_data,
      ssh_keys
    ]
  }

  name        = "${var.project}-web${each.value + 1}"
  server_type = var.server_type_sw_web
  image       = var.default_image
  location    = var.location
  ssh_keys    = concat(values(var.ssh_key_ids), [var.ansible_public_key_id])
  backups     = true

  labels = {
    service-type = "vm"
    vm-role      = "web-service"
    environment  = var.project
    instance     = tostring(each.value + 1)
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  user_data = data.cloudinit_config.user-data-sw-web[each.key].rendered
}

resource "hcloud_server_network" "vm_sw_web_network" {
  for_each = var.server_type_sw_web != null ? {
    for i in range(var.number_instances_sw_web) : "vm_sw_web_${i}" => i
  } : {}
  server_id  = hcloud_server.vm-sw-web[each.key].id
  network_id = var.network_id
}

