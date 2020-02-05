# RDS Storage 
db_storage_type                        = "gp2"
db_max_allocated_storage               = "100"
db_storage_encrypted                   = "true"
db_iops                                = "0"

# RDS Backup and Maintenance
db_backup_window                       = "02:00-03:00"
db_maintenance_window                  = "Mon:03:00-Mon:04:00"
db_backup_retention_period             = "1"
db_skip_final_snapshot                 = "true"
db_copy_tags_to_snapshot               = "true"

# RDS Security
db_deletion_protection                 = "false"
db_publicly_accessible                 = "false"
db_iam_database_authentication_enabled = "false"

# RDS Upgrade Details
db_allow_major_version_upgrade         = "false"
db_auto_minor_version_upgrade          = "true"

# RDS Performance and Monitoring
db_performance_insights_enabled        = "false"
db_monitoring_interval                 = "0"

# RDS R53 Records Details
rds_record_ttl                         = "300"
rds_record_type                        = "CNAME"

# ALL RDS License 
db_license_model = {
  postgres = "postgresql-license"
  mysql    = "general-public-license"
  mariadb  = "general-public-license"
  oracle   = "license-included"
}

# ALL RDS Charecter Sets
db_character_set_name = {
  postgres = ""
  mysql    = ""
  mariadb  = ""
  oracle   = "UTF8"
}

# ALL RDS CloudWatch Logs
db_enabled_cloudwatch_logs_exports = {
  postgres = ["postgresql", "upgrade"]
  mysql    = ["error", "general", "slowquery"]
  mariadb  = ["error", "general", "slowquery", "audit"]
  oracle   = ["alert", "audit", "listener", "trace"]
}

# ALL RDS Port Defaults
db_port = {
  postgres = "5432"
  mysql    = "3306"
  mariadb  = "3306"
  oracle   = "1521"
}

# ALL RDS Parameter Defaults
db_parameter = {
  postgres = [{
    name         = "rds.force_ssl"
    value        = 1
    apply_method = "pending-reboot"
    }, {
    name         = "rds.log_retention_period"
    value        = 10080
    apply_method = "immediate"
    }, {
    name         = "log_statement"
    value        = "all"
    apply_method = "immediate"
  }]
  mysql = [{
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "immediate"
    }, {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "immediate"
  }]
  mariadb = [{
    name  = "max_allowed_packet"
    value = "16777216"
  }]
  oracle = [{
    name         = "open_cursors"
    value        = 4100
    apply_method = "immediate"
  }]
}
