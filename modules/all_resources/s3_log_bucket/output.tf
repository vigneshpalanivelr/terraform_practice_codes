# output "log_bucket_id"                      { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.id)}" }
# output "log_bucket_arn"                     { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.arn)}" }
# output "log_bucket_domain_name"             { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.bucket_domain_name)}" }
# output "log_bucket_regional_domain_name"    { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.bucket_regional_domain_name)}" }
# output "log_hosted_zone_id"                 { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.hosted_zone_id)}" }
# output "log_region"                         { value = "${join(",",aws_s3_bucket.main_s3_bucket.*.region)}" }

output "log_bucket_id"				{ value = "${aws_s3_bucket.s3_log_bucket.id}"				}
output "log_bucket_arn"				{ value = "${aws_s3_bucket.s3_log_bucket.arn}"				}
output "log_bucket_domain_name"			{ value = "${aws_s3_bucket.s3_log_bucket.bucket_domain_name}"		}
output "log_bucket_regional_domain_name"	{ value = "${aws_s3_bucket.s3_log_bucket.bucket_regional_domain_name}"	}
output "log_hosted_zone_id"			{ value = "${aws_s3_bucket.s3_log_bucket.hosted_zone_id}"		}
output "log_region"				{ value = "${aws_s3_bucket.s3_log_bucket.region}"			}
