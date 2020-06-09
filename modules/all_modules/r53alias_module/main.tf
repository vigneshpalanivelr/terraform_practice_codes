data "aws_route53_zone" "selected_r53_zone" {
  provider     = aws.default
  name         = var.r53_zone_name
  private_zone = true
}

data "aws_lb" "lb_filter" {
  count    = var.alias_for == "load-balancer" ? 1 : 0
  provider = aws.default
  name     = var.lb_name
}

data "aws_db_instance" "rds_filter" {
  count    = var.alias_for == "rds-instance" ? 1 : 0
  provider = aws.default
  db_instance_identifier = var.rds_instance_name
}

module "r53alias_record" {
  source          = "../../all_resources/r53alias_record"
  
  zone_id         = data.aws_route53_zone.selected_r53_zone.zone_id
  name            = "${var.r53_record_name}.${data.aws_route53_zone.selected_r53_zone.name}"
  type            = var.r53_record_type
  allow_overwrite = var.r53_overwrite
  alias_name      = var.alias_for == "load-balancer" ? data.aws_lb.lb_filter.0.dns_name : var.alias_for == "rds-instance" ? data.aws_db_instance.rds_filter.0.address        : ""
  alias_zone_id   = var.alias_for == "load-balancer" ? data.aws_lb.lb_filter.0.zone_id  : var.alias_for == "rds-instance" ? data.aws_db_instance.rds_filter.0.hosted_zone_id : ""
}
