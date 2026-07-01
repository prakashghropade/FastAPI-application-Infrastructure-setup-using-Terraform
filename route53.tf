# Route53 Hosted Zone

resource "aws_route53_zone" "main" {
  name = "prakashghorpade.shop"

  tags = {
    Name = "prakashghorpade.shop"
  }
}

resource "aws_route53_record" "root" {

  zone_id = aws_route53_zone.main.zone_id

  name = "prakashghorpade.shop"

  type = "A"

  alias {

    name = aws_lb.alb.dns_name

    zone_id = aws_lb.alb.zone_id

    evaluate_target_health = true
  }

}

resource "aws_route53_record" "www" {

  zone_id = aws_route53_zone.main.zone_id

  name = "www"

  type = "A"

  alias {

    name = aws_lb.alb.dns_name

    zone_id = aws_lb.alb.zone_id

    evaluate_target_health = true
  }

}

resource "aws_route53_record" "blue" {

  zone_id = aws_route53_zone.main.zone_id

  name = "blue"

  type = "A"

  alias {

    name = aws_lb.alb.dns_name

    zone_id = aws_lb.alb.zone_id

    evaluate_target_health = true
  }

}

resource "aws_route53_record" "green" {

  zone_id = aws_route53_zone.main.zone_id

  name = "green"

  type = "A"

  alias {

    name = aws_lb.alb.dns_name

    zone_id = aws_lb.alb.zone_id

    evaluate_target_health = true
  }

}


