output "bucket_id"                  		{ value = "${module.s3_bucket.bucket_id}"			}
output "bucket_arn"                 		{ value = "${module.s3_bucket.bucket_arn}"			}
output "bucket_domain_name"             	{ value = "${module.s3_bucket.bucket_domain_name}"		}
output "bucket_regional_domain_name"    	{ value = "${module.s3_bucket.bucket_regional_domain_name}"	}
output "hosted_zone_id"                 	{ value = "${module.s3_bucket.hosted_zone_id}"			}
output "region"                         	{ value = "${module.s3_bucket.region}"				}
