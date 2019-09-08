#Common KMS Key details
/*
Can be enabled if data source from TF State is required
output "kms_key_name"              {  value = "${data.terraform_remote_state.encryption.outputs.cmk_arn}"}
*/
//Can be disabled if data source from TF State is required
# output "kms_key_name"              {  value = "${data.aws_kms_key.filter_kms_key.id}"}

#Common parameter details
output "security_grp_name"         {  value = "${data.aws_security_group.filter_sg.name}"}
output "parameter_group_name"      {  value = "${module.aws_rds_parameter_group.rds_db_pg_name}"}
output "parameter_group_arn"       {  value = "${module.aws_rds_parameter_group.rds_db_pg_arn}"}
output "option_group_name"         {  value = "${module.aws_rds_option_group.rds_db_og_name}"}
output "option_group_arn"          {  value = "${module.aws_rds_option_group.rds_db_og_arn}"}

#Master Instance details
output "master_address"            {  value = "${module.aws_rds_instance.rds_db_instance_address}"}
output "master_arn"                {  value = "${module.aws_rds_instance.rds_db_instance_arn}"}
output "master_storage"            {  value = "${module.aws_rds_instance.rds_db_instance_storage}"}
output "master_az"                 {  value = "${module.aws_rds_instance.rds_db_instance_az}"}
output "master_retention_period"   {  value = "${module.aws_rds_instance.rds_db_instance_retention_period}"}
output "master_backup_window"      {  value = "${module.aws_rds_instance.rds_db_instance_bkp_window}"}
output "master_ca"                 {  value = "${module.aws_rds_instance.rds_db_instance_ca}"}
output "master_domain"             {  value = "${module.aws_rds_instance.rds_db_instance_domain}"}
output "master_endpoint"           {  value = "${module.aws_rds_instance.rds_db_instance_endpoint}"}
output "master_engine"             {  value = "${module.aws_rds_instance.rds_db_instance_engine}"}
output "master_engine_version"     {  value = "${module.aws_rds_instance.rds_db_instance_engine_ver}"}
output "master_host_zone"          {  value = "${module.aws_rds_instance.rds_db_instance_host_zone}"}
output "master_id"                 {  value = "${module.aws_rds_instance.rds_db_instance_id}"}
output "master_instance_class"     {  value = "${module.aws_rds_instance.rds_db_instance_inst_class}"}
output "master_maintenance_window" {  value = "${module.aws_rds_instance.rds_db_instance_maint_window}"}
output "master_multi_az"           {  value = "${module.aws_rds_instance.rds_db_instance_maz}"}
output "master_dbname"             {  value = "${module.aws_rds_instance.rds_db_instance_dbname}"}
output "master_port"               {  value = "${module.aws_rds_instance.rds_db_instance_port}"}
output "master_resource_id"        {  value = "${module.aws_rds_instance.rds_db_instance_resource_id}"}
output "master_status"             {  value = "${module.aws_rds_instance.rds_db_instance_status}"}
output "master_encryption"         {  value = "${module.aws_rds_instance.rds_db_instance_encryption}"}
output "master_username"           {  value = "${module.aws_rds_instance.rds_db_instance_username}"}
output "master_character_set_name" {  value = "${module.aws_rds_instance.rds_db_instance_character_set}"}
