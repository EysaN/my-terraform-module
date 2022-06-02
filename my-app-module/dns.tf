data "aws_route53_zone" "my_route53_zone_1" {
    name = var.domain
}

locals {
    route53_zone_id = data.aws_route53_zone.my_route53_zone_1.id
    sub_domain = var.env == "prod" ? "" : "${var.env}."
}

resource "aws_route53_record" "route53_myapp_record" {
    zone_id = local.route53_zone_id
    name = "${local.sub_domain}${var.domain}"
    type = "A"

    alias {
      name = aws_lb.alb_4.dns_name
      zone_id = aws_lb.alb_4.zone_id
      evaluate_target_health = true
    }
}

