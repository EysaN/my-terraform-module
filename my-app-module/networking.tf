data "aws_vpc" "default_vpc_1" {
    default = true
}

data "aws_subnets" "default_subnets_2" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default_vpc_1.id]
    }
}


resource "aws_lb_target_group" "target_group_3" {
    name = "${var.app_name}albtargetgroup3"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default_vpc_1.id

    health_check {
      healthy_threshold = 2
      interval = 10
      matcher = "200"
      path = "/"
      timeout = 2
      unhealthy_threshold = 2
    }

    tags = {
      "env" = var.env,
      "workload" = "webapp",
      "service" = "target_group"
    }
}

resource "aws_lb" "alb_4" {
    name = "${var.app_name}alb4"
    security_groups = [ aws_security_group.security_group_alb_1.id, ]
    subnets = data.aws_subnets.default_subnets_2.ids

    tags = {
      "env" = var.env,
      "workload" = "webapp",
      "service" = "alb"
    }
}

resource "aws_alb_listener" "alb_listener_5" {
    load_balancer_arn = aws_lb.alb_4.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.target_group_3.arn
    }
}
