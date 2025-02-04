resource aws_vpc "RIA2" {
  cidr_block = var.vpc["cidr_block"]
}

# DMZ creation
resource "aws_subnet" "DMZ" {
  vpc_id     = var.vpc["vpc_id"]
  cidr_block = var.dmz_subnet["cidr_block"]
}

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnets)
    vpc_id     = var.vpc["vpc_id"]
    cidr_block = var.private_subnets[count.index]["cidr_block"]
}