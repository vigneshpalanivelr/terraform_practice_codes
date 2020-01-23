resource "aws_network_interface" "ec2_eni" {
	subnet_id	= "${var.subnet_id}"
	description	= "${var.description}"
	security_groups	= "${var.security_groups}"
	tags		= "${merge(var.tags, map("Name", var.eni_name))}"
}
