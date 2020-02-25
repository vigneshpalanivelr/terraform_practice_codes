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
  cidr_blocks       = "${var.cidr_block["public_access_ipv4"]}"
  security_group_id = "${data.aws_security_group.sg_filter.id}"
}

module "aws_sg_group_rule__allow_all" {
  source            = "../../../all_resources/sg_group_rule/"
  description       = "ALL Port Public Access"
  type              = "egress"
  protocol          = "ALL"
  from_port         = "0"
  to_port           = "65535"
  cidr_blocks       = "${var.cidr_block["public_access_ipv4"]}"
  security_group_id = "${data.aws_security_group.sg_filter.id}"
}
