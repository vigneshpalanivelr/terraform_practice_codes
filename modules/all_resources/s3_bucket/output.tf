output "bucket_id"                      { value = "${aws_s3_bucket.s3_bucket_with_logging.id}"				}
output "bucket_arn"                     { value = "${aws_s3_bucket.s3_bucket_with_logging.arn}"				}
output "bucket_domain_name"             { value = "${aws_s3_bucket.s3_bucket_with_logging.bucket_domain_name}"		}
output "bucket_regional_domain_name"    { value = "${aws_s3_bucket.s3_bucket_with_logging.bucket_regional_domain_name}" }
output "hosted_zone_id"                 { value = "${aws_s3_bucket.s3_bucket_with_logging.hosted_zone_id}"		}
output "region"                         { value = "${aws_s3_bucket.s3_bucket_with_logging.region}"			}
