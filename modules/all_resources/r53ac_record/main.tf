resource "aws_route53_record" "r53_record" {
  #count           = "${length(var.records) == 0 ? 0 : length(var.records)}"
  zone_id         = "${var.zone_id}"
  name            = "${var.name}"
  ttl             = "${var.ttl}"
  records         = ["${var.records}"]
  type            = "${var.type}"
  allow_overwrite = "${var.allow_overwrite}"
}
