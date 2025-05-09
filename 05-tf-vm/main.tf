module "server" {
  source                  = "../tf-modules/services/vm"
  project                 = data.terraform_remote_state.tfstate-tfstate.outputs.project
  ssh_key_ids             = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
  server_type_bastion     = var.server_type_bastion
  server_type_sw_web      = var.server_type_sw_web
  server_type_sw_admin    = var.server_type_sw_admin
  server_type_pim         = var.server_type_pim
  number_instances_sw_web = var.number_instances_sw_web
  location                = data.terraform_remote_state.tfstate-tfstate.outputs.location
  network_id              = data.terraform_remote_state.tfstate-base.outputs.network_id
}

