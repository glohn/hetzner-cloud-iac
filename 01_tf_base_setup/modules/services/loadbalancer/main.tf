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

resource "hcloud_uploaded_certificate" "lets_encrypt_cert" {
  name        = "${var.project}-cert"
  certificate = file("ssl/fullchain1.pem")
  private_key = file("ssl/privkey1.pem")
}

resource "hcloud_load_balancer_service" "https_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "https"

  http {
    certificates = [hcloud_uploaded_certificate.lets_encrypt_cert.id]
    redirect_http = true
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

