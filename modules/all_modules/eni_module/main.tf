terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_subnet" "filter_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.eni_subnet}"]
  }
}

data "aws_security_group" "filter_sg" {
  name = "${var.eni_security_group}"
}

module "ec2_network_interface" {
  source          = "../../all_resources/ec2_eni/"
  subnet_id       = "${data.aws_subnet.filter_subnet.id}"
  description     = "Network Interface for - ${var.instance_name}"
  security_groups = ["${data.aws_security_group.filter_sg.id}"]
  tags            = "${var.eni_tags}"
  eni_name        = "${var.instance_name}-eni"
}
