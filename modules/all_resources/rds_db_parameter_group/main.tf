resource "aws_db_parameter_group" "parameter_group" {
  description = "Parameter Group for the RDS DB Instance : ${var.identifier}"
  name        = "${var.identifier}-parameter-group"
  family      = "${var.family}"
  tags        = "${merge(var.tags, map("Name", var.identifier))}"
  dynamic "parameter" {
    for_each = "${var.parameter}"
    content {
      name         = "${parameter.value.name}"
      value        = "${parameter.value.value}"
      apply_method = "${lookup(parameter.value, "apply_method", null)}"
    }
  }
}
