terraform {
  backend "s3"{}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_vpc" "vpc_filter" {
  filter {
    name   = "tag:Name"
    values = ["${var.aws_vpc_name}"]
  }
  state = "available"
}

module "aws_sg_group" {
  source	    = "../../all_resources/sg_group/"
  name		    = "${var.sg_group_name}-sg"
  description	= "Security Group for the resource - ${var.resource_name}"
  vpc_id	    = "${data.aws_vpc.vpc_filter.id}"
  tags		    = "${var.tags}"
}
