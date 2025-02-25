output "vpc_id" {
  value       = aws_vpc.main_vpc.id
}

output "dmz_subnet_id" {
  value       = aws_subnet.DMZ.id
}

output "private_subnet_ids" {
  value       = [ for idx, subnet in aws_subnet.private_subnet : {
      id = subnet.id
      name = subnet.tags["Name"]
  }]
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "dmz_route_table_id" {
  value = aws_route_table.dmz_route_table.id
}

output "private_subnet_route_ids" {
  value = [ for route in aws_route_table.private_subnet_routes : route.id]
}