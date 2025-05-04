module "loadbalancer" {
  source = "../tf-modules/services/loadbalancer"

  project                 = data.terraform_remote_state.tfstate-tfstate.outputs.project
  load_balancer_type      = var.load_balancer_type
  load_balancer_location  = data.terraform_remote_state.tfstate-tfstate.outputs.location
  network_id              = data.terraform_remote_state.tfstate-base.outputs.network_id
  managed_certificate     = data.terraform_remote_state.tfstate-base.outputs.managed_certificate_id
  server_type_sw_web      = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_sw_web, null)
  server_type_sw_admin    = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_sw_admin, null)
  server_type_pim         = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_pim, null)
  number_instances_sw_web = try(data.terraform_remote_state.tfstate-vm.outputs.number_instances_sw_web, null)
  server_ids_sw_web       = try(data.terraform_remote_state.tfstate-vm.outputs.server_ids_sw_web, null)
  server_id_sw_admin      = try(data.terraform_remote_state.tfstate-vm.outputs.server_id_sw_admin, null)
  server_id_pim           = try(data.terraform_remote_state.tfstate-vm.outputs.server_ids_pim, null)

}

#module "dns" {
#  source = "../tf-modules/services/dns"
#
#  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  domainname         = var.domainname
#  load_balancer_ipv4 = module.loadbalancer.load_balancer_ipv4
#}
#
#module "firewall" {
#  source = "../tf-modules/global/firewall"
#
#  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  allowed_ssh_ips    = var.allowed_ssh_ips
#  load_balancer_ipv4 = data.terraform_remote_state.tfstate-base.outputs.load_balancer_ipv4
#  server_id          = module.server.server_ids
#  source_ips         = module.server.ipv4_addresses
#}

