output "log_bucket_id" 						{ value = "${module.s3_log_bucket.log_bucket_id}" }
output "log_bucket_arn" 					{ value = "${module.s3_log_bucket.log_bucket_arn}" }
output "log_bucket_domain_name"             { value = "${module.s3_log_bucket.log_bucket_domain_name}" }
output "log_bucket_regional_domain_name"    { value = "${module.s3_log_bucket.log_bucket_regional_domain_name}" }
output "log_hosted_zone_id"                 { value = "${module.s3_log_bucket.log_hosted_zone_id}" }
output "log_region"                         { value = "${module.s3_log_bucket.log_region}" }
