module "server" {
  source           = "./modules/services/vm"
  project          = data.terraform_remote_state.tfstate-tfstate.outputs.project
  server_type      = var.server_type
  location         = data.terraform_remote_state.tfstate-tfstate.outputs.location
  public_key       = var.public_key
  network_id       = data.terraform_remote_state.tfstate-base.outputs.network_id
  load_balancer_id = data.terraform_remote_state.tfstate-base.outputs.load_balancer_id
}

