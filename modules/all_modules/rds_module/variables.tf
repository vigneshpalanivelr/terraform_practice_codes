variable "aws_account_num"            {}
variable "aws_region"                 {}
variable "assume_role"                {}
variable "s3_backend_bucket"          {}
# variable "kms_key_state_prefix"       {}
variable "kms_key_alias_name"         {}

variable "db_engine"                              {}
variable "db_engine_version"                      {}
variable "db_family"                              {}
variable "db_identifier"                          {}
variable "db_license_model"                       { type = "map" }
variable "db_instance_class"                      {}
variable "db_name"                                {}
variable "db_username"                            {}
variable "db_password"                            {}
variable "db_allocated_storage"                   {}
variable "db_max_allocated_storage"               {}
variable "db_storage_type"                        {}
variable "db_iops"                                {}
variable "db_availability_zone"                   {}
variable "db_multi_az"                            {}
variable "db_backup_window"                       {}
variable "db_backup_retention_period"             {}
variable "db_copy_tags_to_snapshot"               {}
variable "db_skip_final_snapshot"                 {}
variable "db_allow_major_version_upgrade"         {}
variable "db_auto_minor_version_upgrade"          {}
variable "db_maintenance_window"                  {}
variable "db_subnet_group_name"                   {}
variable "db_publicly_accessible"                 {}
variable "db_monitoring_interval"                 {}
variable "db_apply_immediately"                   {}
variable "db_deletion_protection"                 {}
variable "db_port"                                { type = "map" }
variable "db_tags"                                { type = "map" }
variable "db_parameter"                           { type = "map" }
variable "db_character_set_name"                  { type = "map" }
variable "db_performance_insights_enabled"        {}
variable "db_iam_database_authentication_enabled" {}
variable "db_enabled_cloudwatch_logs_exports"     { type = "map" }
variable "db_engine_major_version"                {}
variable "db_rds"                                 {}
variable "db_sg"                                  {}
variable "db_action"                              {}
