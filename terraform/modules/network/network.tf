resource "aws_vpc" "DMZ" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "VPC-RIA2"
  }
}

# DMZ creation
resource "aws_subnet" "DMZ" {
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.dmz_subnet["cidr_block"]

  tags = {
    Name = var.dmz_subnet["subnet_name"]
  }
}

# Private subnets creation
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.private_subnets[count.index]["cidr_block"]

  tags = {
    Name = var.private_subnets[count.index]["subnet_name"]
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DMZ.id
}

# Routes for DMZ subnet
resource "aws_route_table" "dmz_route_table" {
  vpc_id = aws_vpc.DMZ.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Routes for private subnets
resource "aws_route_table" "private_subnet_routes" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.DMZ.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "10.0.0.5/32"
  }
}