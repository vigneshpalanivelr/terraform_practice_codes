terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_route53_zone" "selected_r53_zone" {
  name         = "${var.r53_zone_name}"
  private_zone = true
}

module "r53ac_record" {
  source          = "../../all_resources/r53ac_record"
  zone_id         = "${data.aws_route53_zone.selected_r53_zone.zone_id}"
  name            = "${var.r53_record_name}.${data.aws_route53_zone.selected_r53_zone.name}"
  ttl             = "${var.r53_record_ttl}"
  records         = "${var.r53_records}"
  type            = "${var.r53_record_type}"
  allow_overwrite = "${var.r53_overwrite}"
}
