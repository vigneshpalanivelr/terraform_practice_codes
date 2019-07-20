output "log_bucket_id"                      { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.id)}" }
output "log_bucket_arn"                     { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.arn)}" }
output "log_bucket_domain_name"             { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.bucket_domain_name)}" }
output "log_bucket_regional_domain_name"    { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.bucket_regional_domain_name)}" }
output "log_hosted_zone_id"                 { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.hosted_zone_id)}" }
output "log_region"                         { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.region)}" }
output "bucket_id"                      { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.id)}" }
output "bucket_arn"                     { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.arn)}" }
output "bucket_domain_name"             { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.bucket_domain_name)}" }
output "bucket_regional_domain_name"    { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.bucket_regional_domain_name)}" }
output "hosted_zone_id"                 { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.hosted_zone_id)}" }
output "region"                         { value = "${join(",",aws_s3_bucket.main_s3_bucket_with_logging.*.region)}" }
