output "public_ip" {
    value = aws_instance.NatSrv.public_ip
}

output "NatSrv_primary_network_interface_id" {
  value = aws_instance.NatSrv.primary_network_interface_id
}