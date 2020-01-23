terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}


# data source from TF file for ENI
# data "terraform_remote_state" "network_interface" {
# backend = "s3"
# config {
# region = "${var.aws_region}"
# bucket = "${var.s3_backend_bucket}"
# key    = "${var.eni_key_state_prefix}/${var.instance_name}-eni.tfstate"
# }
# }

# data source for KMS
# data "aws_kms_key" "filter_kms_key" {
# key_id = "alias/${var.kms_key_alias_name}"
# }

#data filter for AWS VPC
data "aws_vpc" "vpc_filter" {
  filter {
    name   = "tag:Name"
    values = ["${var.aws_vpc_name}"]
  }
  state = "available"
}

#data filter for ENI
data "aws_network_interface" "ec2_eni" {
  filter {
    name   = "tag:Name"
    values = ["${var.ec2_instance_name}-eni"]
  }
}

#data source for SG
data "aws_security_group" "sg_filter" {
  name   = "${var.ec2_sg_name}"
  vpc_id = "${data.aws_vpc.vpc_filter.id}"
}

#data filters for AMI
data "aws_ami" "ami_filter" {
  owners      = ["309956199498"]
  name_regex  = "^RHEL-8.0.0*"
  most_recent = true
  filter {
    name   = "name"
    values = ["*RHEL-8.0.0*"]
  }
  filter {
    name   = "root-device-type"
    values = ["${var.ec2_ami_root_device_type}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["${var.ec2_virtualization_type}"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  # name              = "tag:Name" 
  # values            = "var.ami_name"
}

#data filters for VPC Subnet
data "aws_subnet" "filter_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_subnet_name}"]
  }
}


data "aws_iam_role" "ec2_profile" {
  name = "${var.ec2_instance_profile_name}"
}


module "aws_ec2_module" {
  source                               = "../../all_resources/ec2_instance/"
  ami                                  = "${data.aws_ami.ami_filter.id}"
  availability_zone                    = "${var.ec2_az}"
  ebs_optimized                        = "${var.ec2_ebs_optimized}"
  disable_api_termination              = "${var.ec2_disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.ec2_instance_initiated_shutdown_behavior}"
  instance_type                        = "${var.ec2_instance_type}"
  monitoring                           = "${var.ec2_monitoring}"
  vpc_security_group_ids               = ["${data.aws_security_group.sg_filter.id}"]
  subnet_id                            = "${data.aws_subnet.filter_subnet.id}"
  iam_instance_profile                 = "${data.aws_iam_role.ec2_profile.id}"
  tags                                 = "${var.ec2_tags}"
  volume_tags                          = "${var.ec2_root_volume_tags}"
  network_interface_id		       = "${data.aws_network_interface.ec2_eni.id}"
  volume_type			       = "${var.ec2_root_volume_type}"
  volume_size			       = "${var.ec2_root_volume_size}"
  iops				       = "${var.ec2_root_volume_iops}"
  delete_on_termination		       = "${var.ec2_root_volume_delete_on_termination}"
}
