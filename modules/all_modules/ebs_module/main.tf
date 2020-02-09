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
  ebs_volume_count  = "${var.ebs_volume_count}"
  ebs_device_names  = "${var.ebs_device_names}"
  availability_zone = "${var.ebs_az}"
  resource_name     = "${var.resource_name}"
  type              = "${var.ebs_type}"
  iops              = "${var.ebs_iops}"
  encrypted         = "${var.ebs_encrypted}"
  tags              = "${var.tags}"
}
