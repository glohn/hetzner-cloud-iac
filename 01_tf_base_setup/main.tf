module "vpc" {
  source = "./modules/vpc"

  project    = var.project
  location   = var.location
  cidr_block = var.cidr_block
}

module "loadbalancer" {
  source = "./modules/services/loadbalancer"

  project                = var.project
  load_balancer_type     = var.load_balancer_type
  load_balancer_location = var.location
  network_id             = module.vpc.network_id
  subnet_ip_range        = module.vpc.subnet_ip_ranges
}

