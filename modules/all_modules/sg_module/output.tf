output "sg_vpc"		{ value = "${data.aws_vpc.vpc_filter.id}"		}

output "sg_id"		{ value = "${module.aws_sg_group.sg_id}"		}
output "sg_arn"		{ value = "${module.aws_sg_group.sg_arn}"		}
output "sg_owner_id"	{ value = "${module.aws_sg_group.sg_owner_id}"		}
output "sg_name"	{ value = "${module.aws_sg_group.sg_name}"		}
output "sg_description"	{ value = "${module.aws_sg_group.sg_description}"	}
