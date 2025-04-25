resource "hcloud_load_balancer" "loadbalancer" {
  name               = "${var.project}-lb"
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.loadbalancer.id
  network_id       = var.network_id
  ip               = cidrhost(var.subnet_ip_range[0], 2) # Zuweisung einer spezifischen IP-Adresse im Subnetz
}

