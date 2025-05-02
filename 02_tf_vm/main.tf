module "firewall-base-rules" {
  source = "../tf-modules/global/firewall"

  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
  allowed_ssh_ips    = var.allowed_ssh_ips
  load_balancer_ipv4 = data.terraforom_remote_state.tfstate-base.outputs.load_balancer_ipv4
}

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

module "firewall-hardened-rules" {
  source = "../tf-modules/global/firewall"

  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
  allowed_ssh_ips    = var.allowed_ssh_ips
  load_balancer_ipv4 = data.terraforom_remote_state.tfstate-base.outputs.load_balancer_ipv4
  source_ips         = module.server.ipv4_address
}

