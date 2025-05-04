resource "hcloud_ssh_key" "default" {
  name       = "guido@local"
  public_key = var.public_key
}

resource "hcloud_server" "this" {
  name        = var.projectname
  server_type = var.server_type
  image       = "debian-12"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
}

