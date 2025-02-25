module "network" {
  source = "./modules/network"

  dmz_subnet = var.dmz_subnet
  private_subnets = var.private_subnets
  vpc = var.vpc
  igw_name = var.igw_name
  allowed_ips = var.allowed_ips

  NatSrv_primary_network_interface_id = module.instances.NatSrv_primary_network_interface_id
}

module "instances" {
  source = "./modules/instances"
  vpc_id = module.network.vpc_id
  dmz_subnet_id = module.network.dmz_subnet_id
  private_subnet_ids = module.network.private_subnet_ids
  private_subnet_sg_ids = module.network.private_subnet_sg_ids
}