s3_bucket_name                = ["terraform-s3-buc-ket-1", "terraform-s3-buc-ket-2"]
s3_log_bucket_name            = ["terraform-s3-buc-log-1"]
s3_bucket_acl                 = "private"
s3_log_bucket_acl             = "log-delivery-write"
s3_logging_enabled            = true
s3_log_bucket_logging_enabled = false
s3_force_destroy              = false
s3_versioning                 = true
s3_versioning_mfa_delete      = false
s3_object_lock_enabled        = "Enabled"
s3_sse_algorithm              = "kms"
s3_algorithms                 = { "kms" = "aws:kms" }
s3_tags = {
  Owner = "Vignesh Palanivel"
  Team  = "terraform-services-india"
  CCPC  = "123456789"
  HSN   = "VERSIONING BUCKET"
}
s3_log_bucket_tags = {
  Owner = "Vignesh Palanivel"
  Team  = "terraform-services-india"
  CCPC  = "123456789"
  HSN   = "VERSIONING LOG BUCKET"
}

