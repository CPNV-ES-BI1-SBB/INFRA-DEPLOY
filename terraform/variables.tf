variable natsrv {
    type        = map(string)
    default     = {
        hostname = "NatSrv"
        IP       = "10.0.0.5/28"
        ami_id      = "ami-08613ebea86dc5d60"
        instance_type = "t3.micro"
        ami_location  = "amazon/debian-12-amd64-20240717-1811"
    }
    description = "NatSrv base information"
}

variable vpc {
    type        = map(string)
    default     = {
        name = "VPC"
        cidr_block = "10.0.0.0/16"
    }
    description = "VPC base information"
}

variable dmz_subnet {
    type        = map(string)
    default     = {
        subnet_name: "DMZ",
        cidr_block: "10.0.0.0/28"
    }
    description = "Public subnet base information"
}

variable private_subnets {
    type       = list(object({
        subnet_name = string
        cidr_block  = string
    }))
    description = "Private subnets base information. List in terraform.tfvars.json"
}

variable keyPairs {
    type       = map(string)
    default    = {
        ELT    = "ELT"
        ETL    = "ETL"
        sysadm = "sysadm" 
    }
    description = "Key pairs for the instances"
}