resource "aws_volume_attachment" "ebs_volume_attachment" {
  count		    = "${var.ebs_volume_count}"
  volume_id         = "${element(var.volume_id,count.index)}"
  instance_id       = "${var.instance_id}"
  force_detach      = "true"
  #device_name       = "${var.ebs_device_names[count.index]["name"]}"
  device_name       = "${element(var.ebs_device_names,count.index)["name"]}"
}
