resource "aws_s3_bucket" "main_s3_bucket" {
	count			= "${length(var.s3_bucket_name)}"
	bucket			= "${element(var.s3_bucket_name,count.index)}"
	region			= "${var.aws_region}"
	acl			= "${var.s3_bucket_acl}"
	tags {
		Name		= "${var.tag_project_code}"
		Department	= "${var.tag_department}"
	}
}
