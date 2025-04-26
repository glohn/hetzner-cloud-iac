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
}

resource "hcloud_server_network" "server-network" {
  server_id  = hcloud_server.instance.id
  network_id = var.network_id
}

