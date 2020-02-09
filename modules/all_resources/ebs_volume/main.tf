resource "aws_ebs_volume" "ebs_volume" {
  count		          = "${var.ebs_volume_count}"
  availability_zone = "${var.availability_zone}"
  size              = "${var.ebs_device_names[count.index]["size"]}"
  type              = "${var.type}"
  iops              = "${var.iops}"
  encrypted         = "${var.encrypted}"
  tags              = "${merge(var.tags, map("Name", join("-", [var.resource_name,var.ebs_device_names[count.index]["name"]])), map("Resource_type", "EBS"))}"
}
