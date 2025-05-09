resource "hcloud_volume" "vm-sw-web-volume" {
  count     = var.number_instances_sw_web
  name      = "${var.project}-volume"
  size      = var.volume_size
  server_id = hcloud_server.vm-sw-web[count.index].id
  automount = true
  format    = "ext4"
}

