variable "natsrv_instance_type" {
    type        = string
    default     = "t3.micro"
    description = "Instance type"
}

variable "natsrv_ami" {
    type        = string
    default     = "ami-08613ebea86dc5d60"
    description = "AMI ID"
}

variable "host_instance_type" {
    type        = string
    default     = "t3.micro"
    description = "Instance type"
}

variable "host_ami" {
    type        = string
    default     = "ami-08613ebea86dc5d60"
    description = "AMI ID"
}

variable "vpc_id" {
    description = "The CIDR block for the VPC"
    type        = string
}

variable "dmz_subnet_id" {
    description = "The CIDR block for the DMZ subnet"
    type        = string
}

variable "created_private_subnets_infos" {
  description = "List of private subnet IDs and naaaames"
  type = list(object({
    id   = string
    name = string
    cidr_block = string
  }))
}

variable "private_subnet_sg_ids" {
  description = "List of private subnet security group IDs"
  type = list(string)
}

variable "nbr_subnet_host" {
    description = "Number of hosts in the cluster"
    type        = number
    default     = 1    
}


locals {
    subnet_hosts = flatten([
        for subnet_index, subnet in var.created_private_subnets_infos : [
            for instance in range(var.nbr_subnet_host) : {
                subnet_id = subnet.id
                subnet_name= subnet.name
                vm_index = instance + 1
                subnet_cidr_block = subnet.cidr_block
                name = "${subnet.name}-host-${format("%02d", instance + 1)}"
                instance_sg_id = var.private_subnet_sg_ids[subnet_index]
            }
        ]   
    ])
}