resource "hcloud_ssh_key" "ssh-key" {
  name       = "guido@local"
  public_key = var.public_key
}

resource "hcloud_server" "instance" {
  name        = var.project
  server_type = var.server_type
  image       = "debian-12"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.ssh-key.id]
  backups     = true
}

resource "hcloud_volume" "instance-volume" {
  name      = "${var.project}-volume"
  size      = var.volume_size
  server_id = hcloud_server.instance.id
  automount = true
  format    = "ext4"
}

resource "hcloud_server_network" "server-network" {
  server_id  = hcloud_server.instance.id
  network_id = var.network_id
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "server"
  load_balancer_id = var.load_balancer_id
  server_id        = hcloud_server.instance.id
  use_private_ip   = true
}

