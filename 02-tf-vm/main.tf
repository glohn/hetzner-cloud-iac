module "server" {
  source                    = "../tf-modules/services/vm"
  project                   = data.terraform_remote_state.tfstate-tfstate.outputs.project
  server_type_bastion       = var.server_type_bastion
  server_type_sw_web        = var.server_type_sw_web
  server_type_sw_admin      = var.server_type_sw_admin
  server_type_pim           = var.server_type_pim
  server_type_rds           = var.server_type_rds
  server_type_elasticsearch = var.server_type_elasticsearch
  server_type_rabbitmq      = var.server_type_rabbitmq
  server_type_redis         = var.server_type_redis
  number_instances_sw_web   = var.number_instances_sw_web
  location                  = data.terraform_remote_state.tfstate-tfstate.outputs.location
  volume_size               = var.volume_size
  user_keys                 = var.user_keys
  network_id                = data.terraform_remote_state.tfstate-base.outputs.network_id
}

