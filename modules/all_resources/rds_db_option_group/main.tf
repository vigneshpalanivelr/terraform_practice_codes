resource "aws_db_option_group" "option_group" {
  option_group_description = "Parameter Group for the RDS DB Instance : ${var.identifier}"
  name                     = "${var.identifier}"
  engine_name              = "${var.engine_name}"
  major_engine_version     = "${var.engine_major_version}"
  tags                     = "${merge(var.tags, map("Name", var.identifier))}"
}
