output "load_balancer_id"			{ value = "${module.aws_elb_module.lb_id}"			}
output "load_balancer_arn"			{ value = "${module.aws_elb_module.lb_arn}"			}
output "load_balancer_dns_name"		{ value = "${module.aws_elb_module.lb_dns_name}"	}
output "load_balancer_zone_id"		{ value = "${module.aws_elb_module.lb_zone_id}"		}