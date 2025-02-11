output "vpc_id" {
  value = aws_vpc.DMZ.id
}

output "dmz_subnet_id" {
  value = aws_subnet.DMZ.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "dmz_route_table_id" {
  value = aws_route_table.dmz_route_table.id
}

output "private_subnets_route_ids" {
  value = aws_route_table.private_subnets_route[*].id
}