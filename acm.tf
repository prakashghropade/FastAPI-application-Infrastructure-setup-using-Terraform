# ACM Certificate
resource "aws_acm_certificate" "cert" {

  domain_name = "prakashghorpade.shop"

  subject_alternative_names = [
    "*.prakashghorpade.shop"
  ]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "prakashghorpade.shop"
  }
}


resource "aws_route53_record" "cert_validation" {

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      value  = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  zone_id = aws_route53_zone.main.zone_id

  name = each.value.name

  type = each.value.type

  ttl = 60

  records = [
    each.value.value
  ]
}


resource "aws_acm_certificate_validation" "cert" {

  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation :
    record.fqdn
  ]

}

