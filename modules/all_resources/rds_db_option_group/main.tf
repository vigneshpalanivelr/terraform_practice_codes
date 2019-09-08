resource "aws_db_option_group" "option_group" {
  count                    = "${var.enabled == "master" ? 1 : 0}"
  option_group_description = "${var.option_group_description}"
  name                     = "${var.identifier}"
  engine_name              = "${var.engine_name}"
  major_engine_version     = "${var.engine_major_version}"
  tags                     = "${merge(var.tags, map("Name", var.identifier))}"
}
