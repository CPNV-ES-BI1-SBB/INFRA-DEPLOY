resource "aws_vpc" "DMZ" {
  cidr_block = var.vpc_cidr_block
}

# DMZ creation
resource "aws_subnet" "DMZ" {
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.dmz_subnet["cidr_block"]
}

# Private subnets creation
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.private_subnets[count.index]["cidr_block"]
}
