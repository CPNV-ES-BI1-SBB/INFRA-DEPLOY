resource "aws_instance" "NatSrv" {
    ami           = var.natsrv_ami
    instance_type = var.natsrv_instance_type
    subnet_id     = var.dmz_subnet_id
    associate_public_ip_address = true
    private_ip    = "10.0.0.10"

    tags = {
        Name = "NatSrv"
    }
    
    key_name = "ria2_sysadm"
}


resource "aws_instance" "cluster_host" {
    count         = length(local.subnet_hosts)
    ami           = var.host_ami
    instance_type = var.host_instance_type
    subnet_id     = local.subnet_hosts[count.index].subnet_id
    associate_public_ip_address = false

    tags = {
        Name = local.subnet_hosts[count.index].name
    }
}