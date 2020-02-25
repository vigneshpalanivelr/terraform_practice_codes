#Common parameter details
# output "kms_key_name"               {  value = "${data.aws_kms_key.filter_kms_key.id}"}
output "security_grp_name"          {  value = "${data.aws_security_group.filter_sg.name}"}

#Slave Instance details
output "replica_address"            {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_address}"}
output "replica_arn"                {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_arn}"}
output "replica_storage"            {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_storage}"}
output "replica_az"                 {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_az}"}
output "replica_retention_period"   {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_retention_period}"}
output "replica_backup_window"      {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_bkp_window}"}
output "replica_ca"                 {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_ca}"}
output "replica_domain"             {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_domain}"}
output "replica_endpoint"           {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_endpoint}"}
output "replica_engine"             {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_engine}"}
output "replica_engine_version"     {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_engine_ver}"}
output "replica_host_zone"          {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_host_zone}"}
output "replica_id"                 {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_id}"}
output "replica_instance_class"     {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_inst_class}"}
output "replica_maintenance_window" {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_maint_window}"}
output "replica_multi_az"           {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_maz}"}
output "replica_dbname"             {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_dbname}"}
output "replica_port"               {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_port}"}
output "replica_resource_id"        {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_resource_id}"}
output "replica_status"             {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_status}"}
output "replica_encryption"         {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_encryption}"}
output "replica_username"           {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_username}"}
output "replica_character_set_name" {  value = "${module.aws_rds_instance_read_replica.rds_db_instance_character_set}"}
