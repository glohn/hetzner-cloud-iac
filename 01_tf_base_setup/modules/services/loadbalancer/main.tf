resource "hcloud_load_balancer" "load_balancer" {
  name               = "${var.project}-lb"
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id       = var.network_id
  ip               = cidrhost(var.subnet_ip_range[0], 2) # Assigning the second IP address in the subnet
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "http"

  http {
  }

  health_check {
    protocol = "http"
    port     = 80
    interval = 30
    timeout  = 5
    retries  = 2

    http {
      path         = "/"
      response     = ""
      tls          = false
      status_codes = ["200"]
    }
  }
}

