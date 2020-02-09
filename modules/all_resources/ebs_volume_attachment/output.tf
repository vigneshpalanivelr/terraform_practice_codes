output "vol_attach_id"		{ value = "${aws_volume_attachment.ebs_volume_attachment.*.volume_id}"	 } 
output "vol_attach_instance_id"	{ value = "${aws_volume_attachment.ebs_volume_attachment.*.instance_id}" }
output "vol_attach_device_name" { value = "${aws_volume_attachment.ebs_volume_attachment.*.device_name}" }
