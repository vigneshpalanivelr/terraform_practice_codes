terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

module "test_kms_key_creation_1" {
  source                      = "../../all_resources/kms_key"
  aws_account_num             = "${var.aws_account_num}"
  aws_user                    = "${var.aws_user}"
  kms_resource_name           = "${var.kms_resource_name}"
  kms_deletion_window_in_days = "${var.kms_deletion_window_in_days}"
  kms_enable_key_rotation     = "${var.kms_enable_key_rotation}"
  tag_project_code            = "${var.tag_project_code}"
  tag_department              = "${var.tag_department}"
}
