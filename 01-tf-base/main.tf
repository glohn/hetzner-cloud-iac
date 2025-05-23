locals {
  project  = data.terraform_remote_state.tfstate-tfstate.outputs.project
  location = data.terraform_remote_state.tfstate-tfstate.outputs.location
}


###########
### VPC ###
###########

module "vpc" {
  source     = "../tf-modules/vpc"
  project    = local.project
  location   = local.location
  cidr_block = var.cidr_block
}


###################
### Data-Stores ###
###################

module "rds" {
  source             = "../tf-modules/data-stores/rds"
  count              = var.server_type_rds != null ? 1 : 0
  project            = local.project
  location           = local.location
  ssh_key_ids        = module.ssh.ssh_key_ids
  ansible_public_key = module.ssh.ansible_public_key
  server_type_rds    = var.server_type_rds
  network_id         = module.vpc.network_id
}

module "redis" {
  source                = "../tf-modules/data-stores/redis"
  count                 = var.server_type_redis != null ? 1 : 0
  project               = local.project
  location              = local.location
  ssh_key_ids           = module.ssh.ssh_key_ids
  ansible_public_key_id = module.ssh.ansible_public_key
  ansible_private_key   = module.ssh.ansible_private_key
  network_id            = module.vpc.network_id
  server_type_redis     = var.server_type_redis
}


##############
### Global ###
##############

module "firewall" {
  source = "../tf-modules/global/firewall"

  project                 = local.project
  subnet_cidrs            = module.vpc.subnet_cidrs
  allowed_ssh_ips         = var.allowed_ssh_ips
  server_id_rabbitmq      = try(module.rabbitmq.server_id_rabbitmq, [])
  server_id_rds           = try(module.rds.server_id_rds, [])
  server_id_redis         = try(module.redis.server_id_redis, [])
  server_id_elasticsearch = try(module.elasticsearch.server_id_elasticsearch, [])
}


################
### Services ###
################

module "certificate" {
  source     = "../tf-modules/services/certificate"
  project    = local.project
  domainname = var.domainname
}

module "elasticsearch" {
  source                    = "../tf-modules/services/elasticsearch"
  count                     = var.server_type_elasticsearch != null ? 1 : 0
  project                   = local.project
  location                  = local.location
  ssh_key_ids               = module.ssh.ssh_key_ids
  ansible_public_key        = module.ssh.ansible_public_key
  server_type_elasticsearch = var.server_type_elasticsearch
  network_id                = module.vpc.network_id
}

module "rabbitmq" {
  source               = "../tf-modules/services/rabbitmq"
  count                = var.server_type_rabbitmq != null ? 1 : 0
  project              = local.project
  location             = local.location
  ssh_key_ids          = module.ssh.ssh_key_ids
  ansible_public_key   = module.ssh.ansible_public_key
  server_type_rabbitmq = var.server_type_rabbitmq
  network_id           = module.vpc.network_id
}

module "ssh" {
  source    = "../tf-modules/services/ssh"
  user_keys = var.user_keys
}

