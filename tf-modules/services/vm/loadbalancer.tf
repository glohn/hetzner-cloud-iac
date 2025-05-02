resource "hcloud_load_balancer_target" "load_balancer_target" {
  count            = var.number_instances_sw_web
  type             = "server"
  load_balancer_id = var.load_balancer_id
  server_id        = hcloud_server.vm-sw-web[count.index].id
  use_private_ip   = true
}

