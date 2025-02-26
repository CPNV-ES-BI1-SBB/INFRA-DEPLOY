resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc["cidr_block"]

  tags = {
    Name = var.vpc["name"]
  }
}

resource "aws_network_acl" "vpc_acl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ACL-${var.vpc["name"]}"
  }
}

resource "aws_network_acl_rule" "vpc_acl_ssh" {
  count = length(var.allowed_ips)
  network_acl_id = aws_network_acl.vpc_acl.id
  rule_number    = 10 + count.index
  action         = "allow"
  protocol       = "tcp"
  from_port      = 22
  to_port        = 22
  rule_action    = "allow"
  egress         = false
  cidr_block     = var.allowed_ips[count.index]
}

resource "aws_network_acl_rule" "vpc_acl_http" {
  count = length(var.allowed_ips)
  network_acl_id = aws_network_acl.vpc_acl.id
  rule_number    = 20 + count.index
  action         = "allow"
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  rule_action    = "allow"
  egress         = false
  cidr_block     = var.allowed_ips[count.index]
}

resource "aws_network_acl_rule" "vpc_acl_https" {
  count = length(var.allowed_ips)
  network_acl_id = aws_network_acl.vpc_acl.id
  rule_number    = 20 + count.index
  action         = "allow"
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  rule_action    = "allow"
  egress         = false
  cidr_block     = var.allowed_ips[count.index]
}

# DMZ creation
resource "aws_subnet" "DMZ" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.dmz_subnet["cidr_block"]

  tags = {
    Name = var.dmz_subnet["subnet_name"]
  }

  depends_on = [aws_vpc.main_vpc]
}

# Private subnets creation
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnets[count.index]["cidr_block"]

  tags = {
    Name = var.private_subnets[count.index]["subnet_name"]
  }

  depends_on = [aws_vpc.main_vpc]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  depends_on = [aws_vpc.main_vpc]

  tags = {
    Name = var.igw_name
  }
}

# Routes for DMZ subnet
resource "aws_route_table" "dmz_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "RT-${var.dmz_subnet["subnet_name"]}"
  }
}

# Routes for private subnets
resource "aws_route_table" "private_subnet_routes" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.vpc["cidr_block"]
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.NatSrv_primary_network_interface_id
  }

  depends_on = [var.NatSrv_primary_network_interface_id]

  tags = {
    Name = "RT-${var.private_subnets[count.index]["subnet_name"]}"
  }
}

# DMZ security group
resource "aws_security_group" "dmz_subnet_sg" {
  name        = "${var.dmz_subnet["subnet_name"]}-sg"
  description = "Security group for public subnet"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.dmz_subnet["subnet_name"]}-sg"
  }
}

# Private subnets security group
resource "aws_security_group" "private_subnet_sg" {
  count = length(var.private_subnets)
  name        = "${var.private_subnets[count.index]["subnet_name"]}-sg"
  description = "Security group for private subnet"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.private_subnets[count.index]["subnet_name"]}-sg"
  }
}

# Security group rules
resource "aws_vpc_security_group_ingress_rule" "dmz_ingress_rules" {
  count = length(var.allowed_ips)
  security_group_id = aws_security_group.dmz_subnet_sg.id
  cidr_ipv4         = var.allowed_ips[count.index]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "SSH access from allowed IPs"
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_private_subnets" {
  count = length(var.private_subnets)
  security_group_id = aws_security_group.dmz_subnet_sg.id
  cidr_ipv4         = var.private_subnets[count.index]["cidr_block"]
  ip_protocol       = "-1"
  description       = "Access from private subnets"
}

resource "aws_vpc_security_group_ingress_rule" "private_subnets_ingress_rules" {
  count = length(var.private_subnets)
  security_group_id = aws_security_group.private_subnet_sg[count.index].id
  cidr_ipv4         = "10.0.0.10/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "SSH access from the nat server"
}

resource "aws_vpc_security_group_egress_rule" "dmz_egress_rules" {
  security_group_id = aws_security_group.dmz_subnet_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_vpc_security_group_egress_rule" "private_subnets_egress_rules" {
  count = length(var.private_subnets)
  security_group_id = aws_security_group.private_subnet_sg[count.index].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# Routes tables associations
resource "aws_route_table_association" "dmz_subnet_association" {
  subnet_id      = aws_subnet.DMZ.id
  route_table_id = aws_route_table.dmz_route_table.id

  depends_on = [aws_subnet.DMZ, aws_route_table.dmz_route_table]
}

resource "aws_route_table_association" "private_subnet_associations" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_routes[count.index].id

  depends_on = [aws_subnet.private_subnet, aws_route_table.private_subnet_routes]
}

# Network interface security group attachment (NAT server)
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.dmz_subnet_sg.id
  network_interface_id = var.NatSrv_primary_network_interface_id

  depends_on = [aws_security_group.dmz_subnet_sg, var.NatSrv_primary_network_interface_id]
}