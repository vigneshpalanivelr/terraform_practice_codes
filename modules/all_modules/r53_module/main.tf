terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_vpc" "selected_vpc" {
  #id = "${var.vpc_name}"
   filter {
     name = "tag-value"
     values = ["${var.vpc_name}"]
   }
   filter {
     name = "tag-key"
     values = ["Name"]
   }
}

module "create_r53_private_zone" {
  source        = "../../all_resources/r53_zone"
  name          = "${var.r53_zone_name}"
  force_destroy = "${var.r53_zone_force_destroy}"
  tags          = "${var.tags}"
  vpc_id        = "${data.aws_vpc.selected_vpc.id}"
}
