resource "aws_lb" "alb" {

  name               = "fastapi-alb"

  internal           = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.sg["alb"].id
  ]

  subnets = [
    aws_subnet.subnets["public-a"].id,
    aws_subnet.subnets["public-b"].id
  ]

  enable_deletion_protection = false

  idle_timeout = 60

  tags = {
    Name = "fastapi-alb"
  }

}


resource "aws_lb_target_group" "tg" {

  for_each = local.target_groups

  name = "${each.key}-tg"

  port = each.value.port

  protocol = "HTTP"

  target_type = "instance"

  vpc_id = aws_vpc.fastapivpc.id

  health_check {

    enabled = true

    path = "/health"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2

  }

  tags = {
    Name = "${each.key}-tg"
  }

}

resource "aws_lb_target_group_attachment" "production" {

  target_group_arn = aws_lb_target_group.tg["blue"].arn

  target_id = aws_instance.servers["blue"].id

  port = 80
}

resource "aws_lb_target_group_attachment" "green" {

  target_group_arn = aws_lb_target_group.tg["green"].arn

  target_id = aws_instance.servers["green"].id

  port = 80

}


resource "aws_lb_target_group_attachment" "blue" {

  target_group_arn = aws_lb_target_group.tg["blue"].arn

  target_id = aws_instance.servers["blue"].id

  port = 80

}


resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.alb.arn

  port     = 443
  protocol = "HTTPS"

  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg["production"].arn

  }

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port     = 80

  protocol = "HTTP"

  default_action {

    type = "redirect" 

    redirect {

      port        = 443

      protocol    = "HTTPS"

      status_code = "HTTP_301"

    }

  }

}

resource "aws_lb_listener_rule" "green" {

  listener_arn = aws_lb_listener.https.arn

  priority = 100

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg["green"].arn

  }

  condition {

    host_header {

      values = [
        "green.prakashghorpade.shop"
      ]

    }

  }

}

resource "aws_lb_listener_rule" "blue" {

  listener_arn = aws_lb_listener.https.arn

  priority = 101

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg["blue"].arn

  }

  condition {

    host_header {

      values = [
        "blue.prakashghorpade.shop"
      ]

    }

  }

}