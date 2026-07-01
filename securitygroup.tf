# security groups
resource "aws_security_group" "sg" {

  for_each = local.security_groups

  name        = "${each.key}-sg"
  description = each.value.description
  vpc_id      = aws_vpc.fastapivpc.id

  tags = {
    Name = "${each.key}-sg"
  }

}

# SG rules
# Application Load Balancer sg
resource "aws_vpc_security_group_ingress_rule" "alb_https" {

  security_group_id = aws_security_group.sg["alb"].id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {

  security_group_id = aws_security_group.sg["alb"].id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 80
  to_port   = 80

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "alb_all" {

  security_group_id = aws_security_group.sg["alb"].id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}


# Application sg
resource "aws_vpc_security_group_ingress_rule" "app_http" {

  security_group_id = aws_security_group.sg["app"].id

  referenced_security_group_id = aws_security_group.sg["alb"].id

  from_port = 80
  to_port   = 80

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "app_https" {

  security_group_id = aws_security_group.sg["app"].id

  referenced_security_group_id = aws_security_group.sg["alb"].id

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {

  security_group_id = aws_security_group.sg["app"].id

  referenced_security_group_id = aws_security_group.sg["bastion"].id

  from_port = 22
  to_port   = 22

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "app_all" {

  security_group_id = aws_security_group.sg["app"].id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}


# Database sg
resource "aws_vpc_security_group_ingress_rule" "postgres" {

  security_group_id = aws_security_group.sg["db"].id

  referenced_security_group_id = aws_security_group.sg["app"].id

  from_port = 5432
  to_port   = 5432

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "redis" {

  security_group_id = aws_security_group.sg["db"].id

  referenced_security_group_id = aws_security_group.sg["app"].id

  from_port = 6379
  to_port   = 6379

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "db_ssh" {

  security_group_id = aws_security_group.sg["db"].id

  referenced_security_group_id = aws_security_group.sg["bastion"].id

  from_port = 22
  to_port   = 22

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "db_all" {

  security_group_id = aws_security_group.sg["db"].id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}


# Bashtion Host sg
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {

  security_group_id = aws_security_group.sg["bastion"].id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 22 
  to_port   = 22

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "bastion_all" {

  security_group_id = aws_security_group.sg["bastion"].id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}

