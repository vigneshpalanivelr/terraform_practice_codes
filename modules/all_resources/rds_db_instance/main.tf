resource "aws_db_instance" "rds_database" {
  identifier                          = "${var.identifier}"
  engine                              = "${var.engine}"
  engine_version                      = "${var.engine_version}"
  instance_class                      = "${var.instance_class}"
  license_model                       = "${var.license_model}"
  name                                = "${var.name}"
  username                            = "${var.username}"
  password                            = "${var.password}"
  port                                = "${var.port}"
  parameter_group_name                = "${var.parameter_group_name}"
  allocated_storage                   = "${var.allocated_storage}"
  max_allocated_storage               = "${var.max_allocated_storage}"
  storage_type                        = "${var.storage_type}"
  storage_encrypted                   = "${var.kms_key_id == "" ? false : true}"
  # kms_key_id                          = "${var.kms_key_id}"
  iops                                = "${var.iops}"
  availability_zone                   = "${var.availability_zone}"
  multi_az                            = "${var.multi_az}"
  backup_window                       = "${var.backup_window}"
  backup_retention_period             = "${var.backup_retention_period}"
  copy_tags_to_snapshot               = "${var.copy_tags_to_snapshot}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  allow_major_version_upgrade         = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade          = "${var.auto_minor_version_upgrade}"
  maintenance_window                  = "${var.maintenance_window}"
  db_subnet_group_name                = "${var.db_subnet_group_name}"
  vpc_security_group_ids              = "${var.vpc_security_group_ids}"
  publicly_accessible                 = "${var.publicly_accessible}"
  monitoring_interval                 = "${var.monitoring_interval}"
  apply_immediately                   = "${var.apply_immediately}"
  deletion_protection                 = "${var.deletion_protection}"
  tags                                = "${merge(var.tags, map("Name", var.identifier))}"
  character_set_name                  = "${var.character_set_name}"
  performance_insights_enabled        = "${var.performance_insights_enabled}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  enabled_cloudwatch_logs_exports     = "${var.enabled_cloudwatch_logs_exports}"
  # option_group_name                   = "${var.option_group_name}"
}
