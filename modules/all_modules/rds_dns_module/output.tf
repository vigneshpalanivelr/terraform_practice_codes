output "route53_master_record_name" { value = module.rds_record_master.aws_route53_record_name }
output "route53_master_record_fqdn" { value = module.rds_record_master.aws_route53_record_fqdn }

/*
output "route53_slave_record_name" { value = module.rds_record_slave.aws_route53_record_name }
output "route53_slave_record_fqdn" { value = module.rds_record_slave.aws_route53_record_fqdn }
*/
