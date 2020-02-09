output "vol_id"		{ value = "${aws_ebs_volume.ebs_volume.*.id}"	} 
output "vol_arn"	{ value = "${aws_ebs_volume.ebs_volume.*.arn}"	}
