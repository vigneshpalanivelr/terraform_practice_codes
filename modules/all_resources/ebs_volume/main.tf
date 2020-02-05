resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.size}"
  type              = "${var.type}"
  iops              = "${var.iops}"
  encrypted         = "${var.encrypted}"
  tags              = "${merge(var.tags, map("Name", var.ebs_name), map("Resource_type", "EBS"))}"
}
