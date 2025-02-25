variable "dmz_subnet" {
    description = "The CIDR block for the DMZ subnet"
    type        = map
}

variable "private_subnets" {
    type       = list(object({
        subnet_name = string
        cidr_block  = string
    }))
    description = "Private subnets base information. List in terraform.tfvars.json"
}

variable "igw_name" {
    type = string
    description = "IGW name"
}

variable "vpc" {
    type        = map(string)
    description = "VPC base information"
}