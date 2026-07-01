output "vpc_id" {
  value = aws_vpc.fastapivpc.id
}

output "public_subnets" {
  value = {
    for k, v in aws_subnet.subnets :
    k => v.id
    if local.subnets[k].type == "public"
  }
}

output "private_app_subnets" {
  value = {
    for k, v in aws_subnet.subnets :
    k => v.id
    if local.subnets[k].type == "private-app"
  }
}

output "private_db_subnets" {
  value = {
    for k, v in aws_subnet.subnets :
    k => v.id
    if local.subnets[k].type == "private-db"
  }
}