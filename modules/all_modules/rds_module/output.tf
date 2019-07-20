output "kms_key_name" {
  value = "${data.terraform_remote_state.encryption.outputs.cmk_arn}"
}

output "security_grp_name" {
  value = "${data.aws_security_group.filter_sg.name}"
}

output "parameter_group_name" {
  value = "${module.aws_rds_parameter_group.rds_db_pg_name}"
}

output "parameter_group_arn" {
  value = "${module.aws_rds_parameter_group.rds_db_pg_arn}"
}

output "option_group_name" {
  value = "${module.aws_rds_option_group.rds_db_og_name}"
}

output "option_group_arn" {
  value = "${module.aws_rds_option_group.rds_db_og_arn}"
}

output "rds_db_instance_address" {
  value = "${module.aws_rds_instance.rds_db_instance_address}"
}

output "rds_db_instance_arn" {
  value = "${module.aws_rds_instance.rds_db_instance_arn}"
}

output "rds_db_instance_storage" {
  value = "${module.aws_rds_instance.rds_db_instance_storage}"
}

output "rds_db_instance_az" {
  value = "${module.aws_rds_instance.rds_db_instance_az}"
}

output "rds_db_instance_retention_period" {
  value = "${module.aws_rds_instance.rds_db_instance_retention_period}"
}

output "rds_db_instance_bkp_window" {
  value = "${module.aws_rds_instance.rds_db_instance_bkp_window}"
}

output "rds_db_instance_ca" {
  value = "${module.aws_rds_instance.rds_db_instance_ca}"
}

output "rds_db_instance_domain" {
  value = "${module.aws_rds_instance.rds_db_instance_domain}"
}

output "rds_db_instance_endpoint" {
  value = "${module.aws_rds_instance.rds_db_instance_endpoint}"
}

output "rds_db_instance_engine" {
  value = "${module.aws_rds_instance.rds_db_instance_engine}"
}

output "rds_db_instance_engine_ver" {
  value = "${module.aws_rds_instance.rds_db_instance_engine_ver}"
}

output "rds_db_instance_host_zone" {
  value = "${module.aws_rds_instance.rds_db_instance_host_zone}"
}

output "rds_db_instance_id" {
  value = "${module.aws_rds_instance.rds_db_instance_id}"
}

output "rds_db_instance_inst_class" {
  value = "${module.aws_rds_instance.rds_db_instance_inst_class}"
}

output "rds_db_instance_maint_window" {
  value = "${module.aws_rds_instance.rds_db_instance_maint_window}"
}

output "rds_db_instance_maz" {
  value = "${module.aws_rds_instance.rds_db_instance_maz}"
}

output "rds_db_instance_dbname" {
  value = "${module.aws_rds_instance.rds_db_instance_dbname}"
}

output "rds_db_instance_port" {
  value = "${module.aws_rds_instance.rds_db_instance_port}"
}

output "rds_db_instance_resource_id" {
  value = "${module.aws_rds_instance.rds_db_instance_resource_id}"
}

output "rds_db_instance_status" {
  value = "${module.aws_rds_instance.rds_db_instance_status}"
}

output "rds_db_instance_encryption" {
  value = "${module.aws_rds_instance.rds_db_instance_encryption}"
}

output "rds_db_instance_username" {
  value = "${module.aws_rds_instance.rds_db_instance_username}"
}

output "rds_db_instance_character_set_name" {
  value = "${module.aws_rds_instance.rds_db_instance_character_set}"
}
