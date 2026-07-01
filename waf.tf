# AWS WAF Web ACL Configuration
resource "aws_wafv2_web_acl" "waf" {
  name        = "fastapi-waf"
  description = "WAF for FastAPI Application Load Balancer"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "fastapi-waf-metrics"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "fastapi-waf"
    Environment = var.environment
  }
}

# Associate WAF Web ACL with the Application Load Balancer
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
