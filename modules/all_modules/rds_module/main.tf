terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

/*
This is a data source from TF State file
1) Disabled Variable kms_key_state_prefix
2) Disabled Output kms_key_name
3) Disabled data filter in module aws_rds_instance
data "terraform_remote_state" "encryption" {
  backend = "s3"
  config = {
    bucket = "${var.s3_backend_bucket}"
    key    = "${var.kms_key_state_prefix}/${var.kms_key_alias_name}-kms-key.tfstate"
    region = "${var.aws_region}"
  }
}

//This is a data source from AWS in real-time

data "aws_kms_key" "filter_kms_key" {
  key_id = "alias/${var.kms_key_alias_name}"
}
*/

data "aws_security_group" "filter_sg" {
  name = "${var.db_sg}"
}

data "aws_db_instance" "filter_rds_instance" {
  count                   = "${var.db_action == "promote-as-master" ? 1 : 0}"
  db_instance_identifier  = "${var.db_identifier}"
}

module "aws_rds_parameter_group" {
  enabled     = "${var.db_action}"
  source      = "../../all_resources/rds_db_parameter_group/"
  identifier  = "${var.db_identifier}-pg"
  description = "Parameter Group for the RDS Instance ${var.db_identifier}"
  family      = "${var.db_family}"
  parameter   = "${var.db_parameter[var.db_rds]}"
  tags        = "${var.db_tags}"
}

module "aws_rds_option_group" {
  enabled                  = "${var.db_action}"
  source                   = "../../all_resources/rds_db_option_group/"
  identifier               = "${var.db_identifier}-og"
  option_group_description = "Option Group for the RDS Instance ${var.db_identifier}"
  engine_name              = "${var.db_engine}"
  engine_major_version     = "${var.db_engine_major_version}"
  tags                     = "${var.db_tags}"
}

module "aws_rds_instance" {
  source                              = "../../all_resources/rds_db_instance/"
  identifier                          = "${var.db_identifier}"
  engine                              = "${var.db_engine}"
  engine_version                      = "${var.db_engine_version}"
  license_model                       = "${var.db_license_model[var.db_rds]}"
  instance_class                      = "${var.db_instance_class}"
  name                                = "${var.db_name}"
  username                            = "${var.db_username}"
  password                            = "${var.db_password}"
  port                                = "${var.db_port[var.db_rds]}"
  parameter_group_name                = "${var.db_action == "master" ? module.aws_rds_parameter_group.rds_db_pg_name[0] : var.db_action == "promote-as-master" ? data.aws_db_instance.filter_rds_instance.*.db_parameter_groups[0][0] : "" }"
  option_group_name                   = "${var.db_action == "master" ? module.aws_rds_option_group.rds_db_og_name[0] : var.db_action == "promote-as-master" ? data.aws_db_instance.filter_rds_instance.*.option_group_memberships[0][0] : "" }"
  allocated_storage                   = "${var.db_allocated_storage}"
  max_allocated_storage               = "${var.db_max_allocated_storage}"
  storage_type                        = "${var.db_storage_type}"
  # kms_key_id                          = "${data.terraform_remote_state.encryption.outputs.cmk_arn}"
  # kms_key_id                          = "${data.aws_kms_key.filter_kms_key.arn}"
  kms_key_id                          = ""
  vpc_security_group_ids              = ["${data.aws_security_group.filter_sg.id}"]
  iops                                = "${var.db_iops}"
  availability_zone                   = "${var.db_action == "master" ? var.db_availability_zone : var.db_action == "promote-as-master" ? data.aws_db_instance.filter_rds_instance.*.availability_zone[0] : "" }"
  multi_az                            = "${var.db_multi_az}"
  backup_window                       = "${var.db_backup_window}"
  backup_retention_period             = "${var.db_backup_retention_period}"
  copy_tags_to_snapshot               = "${var.db_copy_tags_to_snapshot}"
  skip_final_snapshot                 = "${var.db_skip_final_snapshot}"
  allow_major_version_upgrade         = "${var.db_allow_major_version_upgrade}"
  auto_minor_version_upgrade          = "${var.db_auto_minor_version_upgrade}"
  maintenance_window                  = "${var.db_maintenance_window}"
  db_subnet_group_name                = "${var.db_action == "master" ? var.db_subnet_group_name : var.db_action == "promote-as-master" ? data.aws_db_instance.filter_rds_instance.*.db_subnet_group[0] : "" }"
  publicly_accessible                 = "${var.db_publicly_accessible}"
  monitoring_interval                 = "${var.db_monitoring_interval}"
  tags                                = "${var.db_tags}"
  apply_immediately                   = "${var.db_apply_immediately}"
  deletion_protection                 = "${var.db_deletion_protection}"
  performance_insights_enabled        = "${var.db_performance_insights_enabled}"
  iam_database_authentication_enabled = "${var.db_iam_database_authentication_enabled}"
  character_set_name                  = "${var.db_character_set_name[var.db_rds]}"
  enabled_cloudwatch_logs_exports     = "${var.db_enabled_cloudwatch_logs_exports[var.db_rds]}"
}
