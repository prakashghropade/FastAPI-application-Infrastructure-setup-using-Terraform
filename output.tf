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


output "security_group_ids" {

  value = {
    alb     = aws_security_group.sg["alb"].id
    app     = aws_security_group.sg["app"].id
    db      = aws_security_group.sg["db"].id
    bastion = aws_security_group.sg["bastion"].id
  }

}



output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "green_target_group" {
  value = aws_lb_target_group.tg["green"].arn
}

output "blue_target_group" {
  value = aws_lb_target_group.tg["blue"].arn
}

output "listener_arn" {
  value = aws_lb_listener.https.arn
}

output "route53_name_servers" {

  description = "Update these nameservers in Hostinger"

  value = aws_route53_zone.main.name_servers

}

output "hosted_zone_id" {

  value = aws_route53_zone.main.zone_id

}

output "certificate_arn" {

  value = aws_acm_certificate_validation.cert.certificate_arn

}