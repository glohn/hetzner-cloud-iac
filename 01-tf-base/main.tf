module "vpc" {
  source = "../tf-modules/vpc"

  project    = data.terraform_remote_state.tfstate-tfstate.outputs.project
  location   = data.terraform_remote_state.tfstate-tfstate.outputs.location
  cidr_block = var.cidr_block
}

module "ssh" {
  source = "../tf-modules/services/ssh"

  user_keys = var.user_keys
}

module "certificate" {
  source = "../tf-modules/services/certificate"

  project    = data.terraform_remote_state.tfstate-tfstate.outputs.project
  domainname = var.domainname
}

