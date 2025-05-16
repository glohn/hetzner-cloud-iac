resource "hcloud_load_balancer" "load_balancer_sw_web" {
  count              = var.server_type_sw_web != null ? 1 : 0
  name               = "${var.project}-lb"
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "lb_network_sw_web" {
  count            = var.server_type_sw_web != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_web[0].id
  network_id       = var.network_id
}

resource "hcloud_load_balancer" "load_balancer_sw_admin" {
  count              = var.server_type_sw_admin != null ? 1 : 0
  name               = "${var.project}-lb-admin"
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "lb_network_sw_admin" {
  count            = var.server_type_sw_admin != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_admin[0].id
  network_id       = var.network_id
}

resource "hcloud_load_balancer" "load_balancer_pim" {
  count              = var.server_type_pim != null ? 1 : 0
  name               = "${var.project}-lb-pim"
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "lb_network_pim" {
  count            = var.server_type_pim != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_pim[0].id
  network_id       = var.network_id
}

resource "hcloud_load_balancer_service" "https_service_sw_web" {
  count            = var.server_type_sw_web != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_web[0].id
  protocol         = "https"

  http {
    certificates  = [var.managed_certificate]
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

resource "hcloud_load_balancer_target" "load_balancer_target_sw_web" {
  for_each         = { for idx, id in var.server_ids_sw_web : idx => id }
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_web[0].id
  server_id        = each.value
  use_private_ip   = true
  depends_on       = [hcloud_load_balancer_network.lb_network_sw_web]
}

resource "hcloud_load_balancer_service" "https_service_sw_admin" {
  count            = var.server_type_sw_admin != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_admin[0].id
  protocol         = "https"

  http {
    certificates  = [var.managed_certificate]
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

resource "hcloud_load_balancer_target" "load_balancer_target_sw_admin" {
  count            = var.server_type_sw_admin != null ? 1 : 0
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_admin[0].id
  server_id        = var.server_id_sw_admin[count.index]
  use_private_ip   = true
  depends_on       = [hcloud_load_balancer_network.lb_network_sw_admin]
}

resource "hcloud_load_balancer_service" "https_service_pim" {
  count            = var.server_type_pim != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_pim[0].id
  protocol         = "https"

  http {
    certificates  = [var.managed_certificate]
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

resource "hcloud_load_balancer_target" "load_balancer_target_pim" {
  count            = var.server_type_pim != null ? 1 : 0
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer_pim[0].id
  server_id        = var.server_id_pim[count.index]
  use_private_ip   = true
  depends_on       = [hcloud_load_balancer_network.lb_network_pim]
}

resource "hcloud_load_balancer_service" "ssh_service_gitlab" {
  count            = var.server_type_sw_web != null ? 1 : 0
  load_balancer_id = hcloud_load_balancer.load_balancer_sw_web[0].id
  protocol         = "tcp"

  listen_port      = 22
  destination_port = 22

  health_check {
    protocol = "tcp"
    port     = 22
    interval = 30
    timeout  = 5
    retries  = 2
  }
}

