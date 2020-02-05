resource "aws_security_group" "sg_group" {
  name        = "${var.name}"
  description = "${var.description}"
  vpc_id      = "${var.vpc_id}"
  tags	      = "${merge(var.tags, map("Name", var.name), map("Resource_Name", "Security_Group"))}"
}
