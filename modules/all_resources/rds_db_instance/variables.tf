variable "identifier"                           {}
variable "engine"                               {}
variable "engine_version"                       {}
variable "instance_class"                       {}
variable "license_model"                        {}
variable "name"                                 {}
variable "username"                             {}
variable "password"                             {}
variable "port"                                 {}
variable "parameter_group_name"                 {}
variable "allocated_storage"                    {}
variable "max_allocated_storage"                {}
variable "kms_key_id"                           {}
variable "availability_zone"                    {}
variable "multi_az"                             {}
variable "backup_retention_period"              {}
variable "copy_tags_to_snapshot"                {}
variable "skip_final_snapshot"                  {}
variable "allow_major_version_upgrade"          {}
variable "auto_minor_version_upgrade"           {}
variable "db_subnet_group_name"                 {}
variable "vpc_security_group_ids"               {}
variable "publicly_accessible"                  {}
variable "tags"                                 {}
variable "monitoring_interval"                  {}
variable "apply_immediately"                    {}
variable "deletion_protection"                  {}
variable "storage_type"                         { description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note : This behaviour is different from Console where the default is 'gp2'" }
variable "iops"                                 { description = "Setting this implies a variable storage_type of io1" }
variable "backup_window"                        { description = "Must not overlap with variable maintenance_window" }
variable "maintenance_window"                   { description = "Must not overlap with variable backup_window" }
variable "character_set_name"                   {}
variable "performance_insights_enabled"         {}
variable "iam_database_authentication_enabled"  {}
variable "option_group_name"                    {}
variable "enabled_cloudwatch_logs_exports"      { type = "list" }
