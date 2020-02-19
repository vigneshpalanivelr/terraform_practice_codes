terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
    session_name = ""
  }
}

module "sns_topic_warning" {
  source      = "../../all_resources/sns_topic/"
  aws_region  = "${var.aws_region}"
  aws_account = "${var.aws_account_num}"
  topic_name  = "${var.sns_topic_name}-information-alert"
  endpoint    = "${var.sns_endpoint}"
  protocol    = "${var.sns_protocol}"
  tags        = "${var.tags}"
}

module "sns_topic_critical" {
  source      = "../../all_resources/sns_topic/"
  aws_region  = "${var.aws_region}"
  aws_account = "${var.aws_account_num}"
  topic_name  = "${var.sns_topic_name}-critical-alert"
  endpoint    = "${var.sns_endpoint}"
  protocol    = "${var.sns_protocol}"
  tags        = "${var.tags}"
}
