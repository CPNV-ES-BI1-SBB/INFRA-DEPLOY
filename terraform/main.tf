module "network" {
  source = "./modules/network"
  vpc_cidr_block = var.vpc["cidr_block"]

  dmz_subnet = var.dmz_subnet
  private_subnets = var.private_subnets
  vpc = var.vpc
}