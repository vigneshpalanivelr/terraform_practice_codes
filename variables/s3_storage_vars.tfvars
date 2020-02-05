# S3 Bucket Security
s3_force_destroy              = false
s3_bucket_acl                 = "private"
s3_log_bucket_acl             = "log-delivery-write"

# S3 Bucket Logging
s3_logging_enabled            = true
s3_log_bucket_logging_enabled = false

# S3 Bucket Security and Locking
s3_versioning_mfa_delete      = false
s3_object_lock_enabled        = "Enabled"
s3_sse_algorithm              = "kms"
s3_algorithms                 = { "kms" = "aws:kms" }
