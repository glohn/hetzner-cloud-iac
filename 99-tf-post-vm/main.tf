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

