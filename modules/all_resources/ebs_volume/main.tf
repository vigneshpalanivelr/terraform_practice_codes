resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.size}"
  type              = "${var.type}"
  tags              = "${merge(var.tags, map("Name", var.ebs_name))}"
  iops              = "${var.iops}"
  encrypted         = "${var.encrypted}"
}
