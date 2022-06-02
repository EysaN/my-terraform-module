# alb security groups
resource "aws_security_group" "security_group_alb_1" {
    name = "${var.app_name}_sg_alb"
    description = "security group of the ALB for ${var.app_name}"
    vpc_id = data.aws_vpc.default_vpc_1.id
}

resource "aws_security_group_rule" "inbound_security_group_rule_alb_2" {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
    type = "ingress"
    security_group_id = aws_security_group.security_group_alb_1.id
}

resource "aws_security_group_rule" "outbound_security_group_rule_alb_3" {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
    type = "egress"
    security_group_id = aws_security_group.security_group_alb_1.id
}

# ec2 security groups 
resource "aws_security_group" "security_group_lt_4" {
    name = "${var.app_name}_sg_lt"
    description = "security group of the launch template for ${var.app_name}"
    vpc_id = data.aws_vpc.default_vpc_1.id
}

resource "aws_security_group_rule" "inbound_security_group_rule_lt_5" {
    source_security_group_id = aws_security_group.security_group_alb_1.id
    from_port = 80
    to_port = 80
    protocol = "tcp"
    type = "ingress"
    security_group_id = aws_security_group.security_group_lt_4.id
}

resource "aws_security_group_rule" "outbound_security_group_rule_lt_6" {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
    type = "egress"
    security_group_id = aws_security_group.security_group_lt_4.id
}