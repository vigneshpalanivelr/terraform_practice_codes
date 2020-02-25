terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_db_instance" "filter_instance_details" {
  db_instance_identifier = "${var.db_source_identifier}"
}

/*
data "aws_kms_key" "filter_kms_key" {
  key_id = "alias/${var.kms_key_alias_name}"
}
*/

data "aws_security_group" "filter_sg" {
  name = "${var.sg_group_name}"
}

module "aws_rds_instance_read_replica" {
  source                              = "../../all_resources/rds_db_instance_rr/"
  identifier                          = "${var.db_slave_identifier}"
  # replicate_source_db                 = "${var.db_action == "replica" ? var.db_source_identifier : "" }"
  replicate_source_db                 = "${var.db_source_identifier}"
  engine                              = "${var.db_engine}"
  engine_version                      = "${var.db_engine_version}"
  license_model                       = "${var.db_license_model[var.db_rds]}"
  instance_class                      = "${var.db_instance_class}"
  # name                                = "${var.db_name}"
  # username                            = "${var.db_username}"
  # password                            = "${var.db_password}"
  port                                = "${var.db_port[var.db_rds]}"
  parameter_group_name                = "${data.aws_db_instance.filter_instance_details.db_parameter_groups}"
  # option_group_name                   = "${data.aws_db_instance.filter_instance_details.option_group_memberships}"
  allocated_storage                   = "${var.db_allocated_storage}"
  max_allocated_storage               = "${var.db_max_allocated_storage}"
  storage_type                        = "${var.db_storage_type}"
  # kms_key_id                          = "${data.aws_kms_key.filter_kms_key.arn}"
  kms_key_id                          = ""
  vpc_security_group_ids              = ["${data.aws_security_group.filter_sg.id}"]
  iops                                = "${var.db_iops}"
  multi_az                            = "${var.db_multi_az}"
  # availability_zone                   = "${var.db_action == "promote-as-master" ? var.db_availability_zone : "" }"
  # backup_window                       = "${var.db_action == "promote-as-master" ? var.db_backup_window : "" }"
  # backup_retention_period             = "${var.db_action == "promote-as-master" ? var.db_backup_retention_period : "" }"
  availability_zone					  = "${var.db_availability_zone}"
  copy_tags_to_snapshot               = "${var.db_copy_tags_to_snapshot}"
  skip_final_snapshot                 = "${var.db_skip_final_snapshot}"
  allow_major_version_upgrade         = "${var.db_allow_major_version_upgrade}"
  auto_minor_version_upgrade          = "${var.db_auto_minor_version_upgrade}"
  maintenance_window                  = "${var.db_maintenance_window}"
  # db_subnet_group_name                = "${var.vpc_subnet_group}"
  publicly_accessible                 = "${var.db_publicly_accessible}"
  monitoring_interval                 = "${var.db_monitoring_interval}"
  tags                                = "${var.tags}"
  apply_immediately                   = "${var.db_apply_immediately}"
  deletion_protection                 = "${var.db_deletion_protection}"
  performance_insights_enabled        = "${var.db_performance_insights_enabled}"
  iam_database_authentication_enabled = "${var.db_iam_database_authentication_enabled}"
  character_set_name                  = "${var.db_character_set_name[var.db_rds]}"
  enabled_cloudwatch_logs_exports     = "${var.db_enabled_cloudwatch_logs_exports[var.db_rds]}"
}