terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

module "kms_key_creation" {
  source                  = "../../all_resources/kms_key"
  aws_account_num         = "${var.aws_account_num}"
  aws_iam_user            = "${var.aws_iam_user}"
  resource_name           = "${var.kms_key_name}"
  is_enabled              = "${var.kms_is_enabled}"
  deletion_window_in_days = "${var.kms_deletion_window_in_days}"
  enable_key_rotation     = "${var.kms_enable_key_rotation}"
  tags                    = "${var.kms_key_tags}"
}
