provider "aws" {
        region  = "${var.aws_region}"
}

module "main_s3_bucket" {
        source  = "../../all_resources/s3_storage"

        s3_bucket_name          = "${var.s3_bucket_name}"
        aws_region		= "${var.aws_region}"
        s3_bucket_acl           = "${var.s3_bucket_acl}"
        tag_project_code        = "${var.tag_project_code}"
        tag_department          = "${var.tag_department}"
}
