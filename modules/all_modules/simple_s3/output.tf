output "bucket_id" {
        value   = ["${module.main_s3_bucket.bucket_id}"]
}

output "bucket_arn" {
        value   = ["${module.main_s3_bucket.bucket_arn}"]
}
