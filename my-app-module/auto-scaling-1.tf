data "aws_availability_zones" "availability_zones" {
    state = "available"
}


resource "aws_launch_template" "launch_template_1" {
    image_id = var.image_id

    instance_type = var.instance_type

    key_name = var.key_name

    user_data = var.user_data
    
    vpc_security_group_ids = [ aws_security_group.security_group_lt_4.id, ]

    iam_instance_profile {
      name = var.iam_instance_profile
    }

    tag_specifications {
      resource_type = "instance"

      tags = {
        Name = var.app_name
        env = var.env,
        workload = "webapp",
        service = "ec2-instance"
      }
    }
    
    tags = {
      "env" = var.env,
      "workload" = "webapp",
      "service" = "launch-template"
    }
}


resource "aws_autoscaling_group" "aws_autoscaling_group_2" {
    name = "${var.app_name}_autoscaling_group"
    
    desired_capacity = 1
    min_size  = 1
    max_size = 2
    
    availability_zones = data.aws_availability_zones.availability_zones.names

    target_group_arns = [ aws_lb_target_group.target_group_3.arn, ]

    health_check_type = "ELB"

    launch_template {
      id = aws_launch_template.launch_template_1.id
      version = "$Latest"
    }
  
}

resource "aws_autoscaling_policy" "simple_scaling_in_policy_3" {
    name = "scale_in"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    autoscaling_group_name = aws_autoscaling_group.aws_autoscaling_group_2.name
}

resource "aws_autoscaling_policy" "simple_scaling_out_policy_4" {
    name = "scale_out"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    autoscaling_group_name = aws_autoscaling_group.aws_autoscaling_group_2.name
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_cpu_metric_5" {
    alarm_name = "${var.app_name}_cpu_above_50"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"
    statistic = "Average"
    unit = "Percent"
    threshold = 50
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2 
    period = 120

    actions_enabled = true
    alarm_actions = [ aws_autoscaling_policy.simple_scaling_out_policy_4.arn, ]

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.aws_autoscaling_group_2.name
    }

    tags = {
      "env" = var.env
      "workload" = "webapp",
      "service" = "cloudwatch-alarm"
    }
}


resource "aws_cloudwatch_metric_alarm" "cloudwatch_cpu_metric_6" {
    alarm_name = "${var.app_name}_cpu_below_50"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"
    statistic = "Average"
    unit = "Percent"
    threshold = 50
    comparison_operator = "LessThanThreshold"
    evaluation_periods = 2 
    period = 120

    actions_enabled = true
    alarm_actions = [ aws_autoscaling_policy.simple_scaling_in_policy_3.arn, ]

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.aws_autoscaling_group_2.name
    }

    tags = {
      "env" = var.env
      "workload" = "webapp",
      "service" = "cloudwatch-alarm"
    }
}
