module "network" {
  source = "./modules/network"

  dmz_subnet = var.dmz_subnet
  private_subnets = var.private_subnets
  vpc = var.vpc
  igw_name = var.igw_name
}