module "network" {
  source = "./modules/network"

  dmz_subnet = var.dmz_subnet
  private_subnets = var.private_subnets
  vpc = var.vpc
  igw_name = var.igw_name
}

module "instances" {
  source = "./modules/instances"
  vpc_id = module.network.vpc_id
  dmz_subnet_id = module.network.dmz_subnet_id
  private_subnet_ids = module.network.private_subnet_ids
}