output "lb_id"			{ value = "${aws_lb.load_balancer.id}"			}
output "lb_arn"			{ value = "${aws_lb.load_balancer.arn}"			}
output "lb_dns_name"	{ value = "${aws_lb.load_balancer.dns_name}"	}
output "lb_zone_id"		{ value = "${aws_lb.load_balancer.zone_id}"		}