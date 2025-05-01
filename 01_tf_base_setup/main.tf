module "vpc" {
  source = "../tf-modules/vpc"

  project    = data.terraform_remote_state.tfstate-tfstate.outputs.project
  location   = data.terraform_remote_state.tfstate-tfstate.outputs.location
  cidr_block = var.cidr_block
}

module "certificate" {
  source = "../tf-modules/services/certificate"

  project    = data.terraform_remote_state.tfstate-tfstate.outputs.project
  domainname = var.domainname
}

module "loadbalancer" {
  source = "../tf-modules/services/loadbalancer"

  project                = data.terraform_remote_state.tfstate-tfstate.outputs.project
  load_balancer_type     = var.load_balancer_type
  load_balancer_location = data.terraform_remote_state.tfstate-tfstate.outputs.location
  domainname             = var.domainname
  network_id             = module.vpc.network_id
  subnet_ip_range        = module.vpc.subnet_ip_ranges
  managed_certificate    = module.certificate.managed_certificate_id
}

module "firewall" {
  source = "../tf-modules/global/firewall"

  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
  allowed_ssh_ips    = var.allowed_ssh_ips
  load_balancer_ipv4 = module.loadbalancer.load_balancer_ipv4
}

module "dns" {
  source = "../tf-modules/services/dns"

  project            = data.terraform_remote_state.tfstate-tfstate.outputs.project
  domainname         = var.domainname
  load_balancer_ipv4 = module.loadbalancer.load_balancer_ipv4
}

