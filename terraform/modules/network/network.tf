resource "aws_vpc" "DMZ" {
  cidr_block = var.vpc["cidr_block"]

  tags = {
    Name = var.vpc["name"]
  }
}

# DMZ creation
resource "aws_subnet" "DMZ" {
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.dmz_subnet["cidr_block"]

  tags = {
    Name = var.dmz_subnet["subnet_name"]
  }

  depends_on = [aws_vpc.DMZ]
}

# Private subnets creation
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.DMZ.id
  cidr_block = var.private_subnets[count.index]["cidr_block"]

  tags = {
    Name = var.private_subnets[count.index]["subnet_name"]
  }

  depends_on = [aws_vpc.DMZ]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DMZ.id

  depends_on = [aws_vpc.DMZ]

  tags = {
    Name = var.igw_name
  }
}

# Routes for DMZ subnet
resource "aws_route_table" "dmz_route_table" {
  vpc_id = aws_vpc.DMZ.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]
}

# Routes for private subnets
resource "aws_route_table" "private_subnet_routes" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.DMZ.id

  route {
    cidr_block = var.vpc["cidr_block"]
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.NatSrv.primary_network_interface_id
  }

  depends_on = [module.instances.aws_instance.NatSrv]
}