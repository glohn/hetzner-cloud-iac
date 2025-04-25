resource "hcloud_ssh_key" "default" {
  name       = "guido@local"
  public_key = var.public_key
}

resource "hcloud_server" "instance" {
  name        = var.project
  server_type = var.server_type
  image       = "debian-12"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
}

resource "hcloud_server_subnet" "instance-subnet" {
  network_id = var.network_id
  type =
  ip_range =
  network_zone =
}

