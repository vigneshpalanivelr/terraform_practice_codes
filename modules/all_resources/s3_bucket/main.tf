resource "aws_s3_bucket" "s3_bucket_with_logging" {
  # count         = "${var.logging_enabled == true ? length(var.bucket_name) : 0}"
  # bucket        = "${element(var.bucket_name, count.index)}"
  bucket        = "${var.bucket_name}"
  region        = "${var.aws_region}"
  acl           = "${var.bucket_acl}"
  force_destroy = "${var.force_destroy}"
  versioning {
    enabled    = "${var.versioning}"
    mfa_delete = "${var.mfa_delete}"
  }
  logging {
    target_bucket = "${var.log_bucket_name}"
    target_prefix = "log/"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.sse_algorithm == "kms" ? var.kms_master_key_id : null }"
        sse_algorithm     = "${lookup(var.s3_algorithms,var.sse_algorithm,"AES256")}"
      }
    }
  }
  object_lock_configuration {
    object_lock_enabled = "${var.object_lock_enabled}"
  }
  tags          = "${merge(var.tags, map("Name", var.bucket_name), map("Resource_Name", "S3_Bucket"))}"
}
