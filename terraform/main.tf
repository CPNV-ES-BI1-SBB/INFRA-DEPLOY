module "network" {
  source = "./modules/network"
  vpc_cidr_block = var.vpc["cidr_block"]

  dmz_subnet = var.dmz_subnet
  private_subnets = var.private_subnets
}

module "instances" {
  source = "./modules/instances"
  vpc_id = module.network.vpc_id
  dmz_subnet_id = module.network.dmz_subnet_id
  private_subnet_ids = module.network.private_subnet_ids
}