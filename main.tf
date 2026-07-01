resource "aws_vpc" "fastapivpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "fastapi-vpc"
    Environment= var.environment
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fastapivpc.id

  tags = {
    Name = "fastapi-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnets" {

  for_each = local.subnets

  vpc_id = aws_vpc.fastapivpc.id

  cidr_block = each.value.cidr

  availability_zone = each.value.az

  map_public_ip_on_launch = each.value.type == "public"

  tags = {
    Name = each.key
    Type = each.value.type
  } 

}

resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "fastapi-nat-eip"
    Environment = var.environment
  }

}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.subnets["public-a"].id

  tags = {
    Name = "fastapi-nat"
    Environment = var.environment
  }

}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.fastapivpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
    Environment = var.environment
  }

}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.fastapivpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }

}

resource "aws_route_table_association" "public" {

  for_each = {
    for k, v in local.subnets :
    k => v
    if v.type == "public"
  }

  subnet_id = aws_subnet.subnets[each.key].id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private" {

  for_each = {
    for k, v in local.subnets :
    k => v
    if v.type != "public"
  }

  subnet_id = aws_subnet.subnets[each.key].id

  route_table_id = aws_route_table.private.id
}

