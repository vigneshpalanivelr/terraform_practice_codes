db_max_allocated_storage               = "100"
db_backup_window                       = "02:00-03:00"
db_maintenance_window                  = "Mon:03:00-Mon:04:00"
# db_availability_zone                   = "ap-south-1a"
db_subnet_group_name                   = "default"
db_sg                                  = "default"
db_storage_type                        = "gp2"
db_iops                                = "0"
db_backup_retention_period             = "1"
db_monitoring_interval                 = "0"
db_deletion_protection                 = "false"
db_allow_major_version_upgrade         = "false"
db_storage_encrypted                   = "true"
db_auto_minor_version_upgrade          = "true"
db_copy_tags_to_snapshot               = "true"
db_skip_final_snapshot                 = "true"
db_publicly_accessible                 = "false"
db_performance_insights_enabled        = "false"
db_iam_database_authentication_enabled = "false"

db_license_model = {
  postgres = "postgresql-license"
  mysql    = "general-public-license"
  mariadb  = "general-public-license"
  oracle   = "license-included"
}

db_character_set_name = {
  postgres = ""
  mysql    = ""
  mariadb  = ""
  oracle   = "UTF8"
}

db_enabled_cloudwatch_logs_exports = {
  postgres = ["postgresql", "upgrade"]
  mysql    = ["error", "general", "slowquery"]
  mariadb  = ["error", "general", "slowquery", "audit"]
  oracle   = ["alert", "audit", "listener", "trace"]
}

db_port = {
  postgres = "5432"
  mysql    = "3306"
  mariadb  = "3306"
  oracle   = "1521"
}

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

db_tags = {
  Owner = "Vignesh Palanivel"
  Team  = "terraform-services-india"
  CCPC  = "123456789"
  HSN   = "RDS DB INSTANCE"
}
