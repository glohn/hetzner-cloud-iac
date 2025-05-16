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
  server_ids_sw_web       = data.terraform_remote_state.tfstate-vm.outputs.server_ids_sw_web
  server_id_sw_admin      = data.terraform_remote_state.tfstate-vm.outputs.server_id_sw_admin
  server_id_pim           = data.terraform_remote_state.tfstate-vm.outputs.server_id_pim

}

module "dns" {
  source = "../tf-modules/services/dns"

  project                     = data.terraform_remote_state.tfstate-tfstate.outputs.project
  domainname                  = data.terraform_remote_state.tfstate-base.outputs.domainname
  load_balancer_sw_web_ipv4   = module.loadbalancer.load_balancer_sw_web_ipv4
  load_balancer_sw_admin_ipv4 = module.loadbalancer.load_balancer_sw_admin_ipv4
  load_balancer_pim_ipv4      = module.loadbalancer.load_balancer_pim_ipv4
  server_type_sw_web          = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_sw_web, null)
  server_type_sw_admin        = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_sw_admin, null)
  server_type_pim             = try(data.terraform_remote_state.tfstate-vm.outputs.server_type_pim, null)
}

module "firewall" {
  source = "../tf-modules/global/firewall"

  project                     = data.terraform_remote_state.tfstate-tfstate.outputs.project
  subnet_cidrs                = data.terraform_remote_state.tfstate-base.outputs.subnet_cidrs
  allowed_ssh_ips             = var.allowed_ssh_ips
  load_balancer_sw_web_ipv4   = module.loadbalancer.load_balancer_sw_web_ipv4
  load_balancer_sw_admin_ipv4 = module.loadbalancer.load_balancer_sw_admin_ipv4
  load_balancer_pim_ipv4      = module.loadbalancer.load_balancer_pim_ipv4
  server_id_bastion           = data.terraform_remote_state.tfstate-vm.outputs.server_id_bastion
  server_ids_sw_web           = data.terraform_remote_state.tfstate-vm.outputs.server_ids_sw_web
  server_id_sw_admin          = data.terraform_remote_state.tfstate-vm.outputs.server_id_sw_admin
  server_id_pim               = data.terraform_remote_state.tfstate-vm.outputs.server_id_pim
  server_id_rabbitmq          = try(data.terraform_remote_state.tfstate-services.outputs.server_id_rabbitmq, [])
  server_id_rds               = try(data.terraform_remote_state.tfstate-services.outputs.server_id_rds, [])
  server_id_redis             = try(data.terraform_remote_state.tfstate-services.outputs.server_id_redis, [])
  server_id_elasticsearch     = try(data.terraform_remote_state.tfstate-services.outputs.server_id_elasticsearch, [])
}

