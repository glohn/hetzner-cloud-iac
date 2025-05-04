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

