variable "instance_type" {
    type        = string
    default     = "t3.micro"
    description = "Instance type"
}

variable "ami" {
    type        = string
    default     = "ami-08613ebea86dc5d60"
    description = "AMI ID"
}

variable "vpc" {
    type        = map(string)
    default     = {
        name = "VPC"
        cidr_block = "10.0.0.0/16"
    }
    description = "VPC base information"
}

variable "dmz_subnet" {
    type        = map(string)
    default     = {
        subnet_name: "DMZ",
        cidr_block: "10.0.0.0/28"
    }
    description = "Public subnet base information"
}

variable "private_subnets" {
    type       = list(object({
        subnet_name = string
        cidr_block  = string
    }))
    description = "Private subnets base information. List in terraform.tfvars.json"
}

variable "allowed_ips" {
    type        = list(string)
    default     = ["0.0.0.0/0"]
    description = "Allowed IPs for the security group"
}

variable "igw_name" {
    type = string
    description = "IGW name"
}

variable "keyPairs" {
    type       = map(string)
    default    = {
        ELT    = "ELT"
        ETL    = "ETL"
        sysadm = "sysadm" 
    }
    description = "Key pairs for the instances"
}