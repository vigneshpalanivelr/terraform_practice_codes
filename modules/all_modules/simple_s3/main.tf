terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

module "main_s3_bucket" {
  source           = "../../all_resources/s3_storage"
  s3_bucket_name   = "${var.s3_bucket_name}"
  aws_region       = "${var.aws_region}"
  s3_bucket_acl    = "${var.s3_bucket_acl}"
  tag_project_code = "${var.tag_project_code}"
  tag_department   = "${var.tag_department}"
}
