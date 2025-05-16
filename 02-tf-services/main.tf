#module "elasticsearch" {
#  source                    = "../tf-modules/services/elasticsearch"
#  project                   = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  ssh_key_ids               = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
#  ansible_public_key        = data.terraform_remote_state.tfstate-base.outputs.ansible_public_key
#  server_type_elasticsearch = var.server_type_elasticsearch
#  location                  = data.terraform_remote_state.tfstate-tfstate.outputs.location
#  network_id                = data.terraform_remote_state.tfstate-base.outputs.network_id
#}
#
#module "rabbitmq" {
#  source               = "../tf-modules/services/rabbitmq"
#  project              = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  ssh_key_ids          = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
#  ansible_public_key   = data.terraform_remote_state.tfstate-base.outputs.ansible_public_key
#  server_type_rabbitmq = var.server_type_rabbitmq
#  location             = data.terraform_remote_state.tfstate-tfstate.outputs.location
#  network_id           = data.terraform_remote_state.tfstate-base.outputs.network_id
#}
#
#module "rds" {
#  source             = "../tf-modules/data-stores/rds"
#  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  ssh_key_ids        = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
#  ansible_public_key = data.terraform_remote_state.tfstate-base.outputs.ansible_public_key
#  server_type_rds    = var.server_type_rds
#  location           = data.terraform_remote_state.tfstate-tfstate.outputs.location
#  network_id         = data.terraform_remote_state.tfstate-base.outputs.network_id
#}
#
#module "redis" {
#  source              = "../tf-modules/data-stores/redis"
#  project             = data.terraform_remote_state.tfstate-tfstate.outputs.project
#  ssh_key_ids         = data.terraform_remote_state.tfstate-base.outputs.ssh_key_ids
#  ansible_public_key  = data.terraform_remote_state.tfstate-base.outputs.ansible_public_key
#  ansible_private_key = data.terraform_remote_state.tfstate-base.outputs.ansible_private_key
#  server_type_redis   = var.server_type_redis
#  location            = data.terraform_remote_state.tfstate-tfstate.outputs.location
#  network_id          = data.terraform_remote_state.tfstate-base.outputs.network_id
#}

