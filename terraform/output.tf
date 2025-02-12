output "vpc_id" {
  value       = module.network.vpc_id
}

output "public_ip" {
  value       = module.instances.public_ip
}