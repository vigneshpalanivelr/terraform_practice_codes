# This modue can also be used to create normal bucket
# without loggng enables

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
data "aws_kms_key" "kms_alias_name" {
  key_id = "alias/${var.kms_resource_name}"
}
*/

module "s3_log_bucket" {
  source              = "../../all_resources/s3_log_bucket"
  aws_region          = "${var.aws_region}"
  bucket_name         = "${var.s3_log_bucket_name}"
  bucket_acl          = "${var.s3_log_bucket_acl}"
  logging_enabled     = "${var.s3_log_bucket_logging_enabled}"
  tags                = "${var.tags}"
  force_destroy       = "${var.s3_force_destroy}"
  versioning          = "${var.s3_versioning}"
  object_lock_enabled = "${var.s3_object_lock_enabled}"
  mfa_delete          = "${var.s3_versioning_mfa_delete}"
  sse_algorithm       = "${var.s3_sse_algorithm}"
  s3_algorithms       = "${var.s3_algorithms}"
  # kms_master_key_id   = "${data.aws_kms_key.kms_alias_name.arn}"

}
