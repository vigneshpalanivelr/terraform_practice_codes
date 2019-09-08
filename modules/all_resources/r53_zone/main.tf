resource "aws_route53_zone" "private_hosted_zone" {
  name          = "${var.name}"
  comment       = "Private Zone for ${var.name}"
  force_destroy = "${var.force_destroy}"
  tags          = "${merge(var.tags, map("Name", var.name))}"
  vpc {
    vpc_id = "${var.vpc_id}"
  }
}
