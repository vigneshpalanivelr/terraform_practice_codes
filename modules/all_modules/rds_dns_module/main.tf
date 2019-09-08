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
This is a data source from TF State file instead we can use data filter as below
1) Disabled Variable kms_key_state_prefix
2) Disabled Output kms_key_name
3) Disabled data filter in module aws_rds_instance
data "terraform_remote_state" "rds_details" {
  backend = "s3"
  config = {
    bucket = "${var.s3_backend_bucket}"
    key    = "${var.rds_key_state_prefix}/${var.db_identifier}.tfstate"
    region = "${var.aws_region}"
  }
}
*/

data "aws_db_instance" "master_details" {
  #count                   = 1
  db_instance_identifier  = "${var.db_identifier}"
}

data "aws_route53_zone" "selected_rds_zone" {
  name         = "${var.aws_r53_zone}"
  private_zone = true
}

module "rds_record_master" {
  source          = "../../all_resources/r53ac_record"
  zone_id         = "${data.aws_route53_zone.selected_rds_zone.zone_id}"
  name            = "${var.db_route53_name}.${data.aws_route53_zone.selected_rds_zone.name}"
  ttl             = "${var.rds_record_ttl}"
  records         = "${data.aws_db_instance.master_details.address}"
  type            = "${var.rds_record_type}"
  allow_overwrite = true
}

/*
//This module is created for Read-Replica Route53 creation
//But in the case of master - slave switching, need to swith the r53 name also
//Hence it should be seperate TF-STATE files
//1) Commenting this module rather removing
//2) Commenting output of this module
//3) Commenting variable db_read_replica of this module
data "aws_db_instance" "replica_details" {
  count                   = "${var.db_read_replica == "true" ? 1 : 0}"
  db_instance_identifier  = "${var.db_identifier}-${var.db_rds}-rds-rr"
}
module "rds_record_slave" {
  source          = "../../all_resources/r53ac_record"
  zone_id         = "${data.aws_route53_zone.selected_rds_zone.zone_id}"
  name            = "${var.db_identifier}-${var.db_rds}-rds-rr.${data.aws_route53_zone.selected_rds_zone.name}"
  ttl             = "${var.rds_record_ttl}"
  records         = "${var.db_read_replica == "true" ? data.aws_db_instance.replica_details.*.address : []}"
  type            = "${var.rds_record_type}"
  allow_overwrite = true
}
*/
