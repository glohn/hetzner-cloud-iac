module "server" {
  source      = "./modules/server"
  project     = var.projectname
  server_type = var.server_type
  location    = var.location
  public_key  = var.public_key
}

module "rescue" {
  source       = "./modules/rescue"
  hcloud_token = var.hcloud_token
  server_id    = module.server.id
  server_ip    = module.server.ipv4_address
  ssh_key_id   = module.server.ssh_key_id
}

module "talos" {
  source        = "./modules/talos"
  server_ip     = module.server.ipv4_address
  talos_version = var.talos_version

  depends_on = [module.rescue]
}

