resource "aws_security_group_rule" "sg_group_rule" {
  description       = "${var.description}"
  type              = "${var.type}"
  protocol          = "${var.protocol}"
  from_port         = "${var.from_port}"
  to_port           = "${var.to_port}"
  cidr_blocks       = "${var.cidr_blocks}"
  security_group_id = "${var.security_group_id}"
}
