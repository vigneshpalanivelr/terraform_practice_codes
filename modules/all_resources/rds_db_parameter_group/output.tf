output "rds_db_pg_name" { value = "${aws_db_parameter_group.parameter_group.*.id}" }
output "rds_db_pg_arn" { value = "${aws_db_parameter_group.parameter_group.*.arn}" }
