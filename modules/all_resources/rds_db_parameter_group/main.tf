resource "aws_db_parameter_group" "parameter_group" {
  # count                    = "${var.enabled == "master" ? 1 : 0}"
  description = "${var.description}"
  name        = "${var.identifier}"
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
