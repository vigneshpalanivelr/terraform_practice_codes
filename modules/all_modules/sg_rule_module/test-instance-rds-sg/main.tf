terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_security_group" "sg_filter" {
  filter {
    name   = "tag:Name"
    values = ["${var.sg_group_name}-sg"]
  }
}

module "aws_sg_group_rule_pg_rds_allow_all" {
  source            = "../../../all_resources/sg_group_rule/"
  description       = "${var.port_details["ssh"]["description"]} Public Access"
  type              = "ingress"
  protocol          = "${var.port_details["pg_rds"]["protocol"]}"
  from_port         = "${var.port_details["pg_rds"]["port"]}"
  to_port           = "${var.port_details["pg_rds"]["port"]}"
  cidr_blocks       = ["${var.cidr_block["public_access_ipv4"]["ip_range"]}"]
  security_group_id = "${data.aws_security_group.sg_filter.id}"
}

module "aws_sg_group_rule__allow_all" {
  source            = "../../../all_resources/sg_group_rule/"
  description       = "${var.port_details["all_subnet_default"]["description"]}"
  type              = "egress"
  protocol          = "${var.cidr_block["all_subnet_default"]["protocol"]}"
  from_port         = "${var.cidr_block["all_subnet_default"]["from_port"]}"
  to_port           = "${var.cidr_block["all_subnet_default"]["to_port"]}"
  cidr_blocks       = ["${var.cidr_block["all_subnet_default"]["ip_range"]}"]
  security_group_id = "${data.aws_security_group.sg_filter.id}"
}