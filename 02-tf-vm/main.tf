locals {
  project  = data.terraform_remote_state.tfstate-tfstate.outputs.project
  location = data.terraform_remote_state.tfstate-tfstate.outputs.location
}


################
### Services ###
################

module "dns" {
  source                      = "../tf-modules/services/dns"
  project                     = local.project
  domainname                  = data.terraform_remote_state.tfstate-base.outputs.domainname
  load_balancer_sw_web_ipv4   = module.loadbalancer.load_balancer_sw_web_ipv4
  load_balancer_sw_admin_ipv4 = module.loadbalancer.load_balancer_sw_admin_ipv4
  load_balancer_pim_ipv4      = module.loadbalancer.load_balancer_pim_ipv4
  server_type_sw_web          = var.server_type_sw_web
  server_type_sw_admin        = var.server_type_sw_admin
  server_type_pim             = var.server_type_pim
}

module "loadbalancer" {
  source                  = "../tf-modules/services/loadbalancer"
  project                 = local.project
  load_balancer_location  = local.location
  load_balancer_type      = var.load_balancer_type
  network_id              = data.terraform_remote_state.tfstate-base.outputs.network_id
  managed_certificate     = data.terraform_remote_state.tfstate-base.outputs.managed_certificate_id
  server_type_sw_web      = var.server_type_sw_web
  server_type_sw_admin    = var.server_type_sw_admin
  server_type_pim         = var.server_type_pim
  number_instances_sw_web = var.number_instances_sw_web
  server_ids_sw_web       = module.server.server_ids_sw_web
  server_id_sw_admin      = module.server.server_id_sw_admin
  server_id_pim           = module.server.server_id_pim
}

module "server" {
  source                  = "../tf-modules/services/vm"
  project                 = local.project
  location                = local.location
  ssh_key_ids             = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
  ansible_public_key_id   = data.terraform_remote_state.tfstate-base.outputs.ansible_public_key_ids
  ansible_private_key     = data.terraform_remote_state.tfstate-base.outputs.ansible_private_key
  network_id              = data.terraform_remote_state.tfstate-base.outputs.network_id
  firewall_id_ssh         = data.terraform_remote_state.tfstate-base.outputs.firewall_id_vm_ssh
  server_type_bastion     = var.server_type_bastion
  server_type_sw_web      = var.server_type_sw_web
  server_type_sw_admin    = var.server_type_sw_admin
  server_type_pim         = var.server_type_pim
  number_instances_sw_web = var.number_instances_sw_web
}

