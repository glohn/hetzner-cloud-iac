module "server" {
  source      = "./modules/services/vm"
  project     = var.projectname
  server_type = var.server_type
  location    = var.location
  public_key  = var.public_key
}

