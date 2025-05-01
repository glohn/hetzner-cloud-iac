module "server" {
  source           = "../tf-modules/services/vm"
  project          = data.terraform_remote_state.tfstate-tfstate.outputs.project
  server_type      = var.server_type
  location         = data.terraform_remote_state.tfstate-tfstate.outputs.location
  volume_size      = var.volume_size
  user_keys        = var.user_keys
  network_id       = data.terraform_remote_state.tfstate-base.outputs.network_id
  firewall_ids     = data.terraform_remote_state.tfstate-base.outputs.firewall_ids
  load_balancer_id = data.terraform_remote_state.tfstate-base.outputs.load_balancer_id
}

