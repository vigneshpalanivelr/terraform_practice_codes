terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

/*
data "aws_kms_key" "filter_kms_key" {
  key_id = "alias/${var.kms_key_alias_name}"
}
*/

module "aws_ebs_volume" {
  source            = "../../all_resources/ebs_volume/"
  availability_zone = "${var.ebs_availability_zone}"
  size              = "${var.ebs_size}"
  type              = "${var.ebs_type}"
  tags              = "${var.ebs_tags}"
  ebs_name          = "${var.ebs_name}"
  iops              = "${var.ebs_iops}"
  encrypted         = "${var.ebs_encrypted}"
}
