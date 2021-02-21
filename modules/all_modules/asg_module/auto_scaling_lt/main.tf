data "aws_iam_role" "ec2_profile" {
  name = "${var.ec2_instance_profile_name}"
}

#data filter for AWS VPC
data "aws_vpc" "vpc_filter" {
  filter {
    name   = "tag:Name"
    values = ["${var.aws_vpc_name}"]
  }
  state = "available"
}

#data source for SG
data "aws_security_group" "sg_filter" {
  name   = "${var.asg_lt_sg_name}-sg"
  vpc_id = "${data.aws_vpc.vpc_filter.id}"
}

#data filters for AMI
data "aws_ami" "ami_filter" {
  owners      = ["${var.ami_owner_id}"]
  name_regex  = "^${var.ami_regex}*"
  most_recent = true
  filter {
    name   = "name"
    values = ["*${var.ami_regex}*"]
  }
  filter {
    name   = "root-device-type"
    values = ["${var.ami_root_device_type}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["${var.ami_virtualization_type}"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  # name              = "tag:Name" 
  # values            = "var.ami_name"
}

data "template_file" "userdata_tpl" {
  template = "${file("${path.module}/userdata.tpl")}"
  vars = {
    ssh_group   = "${var.ssh_group}"
    sudo_group  = "${var.sudo_group}"
    root_user   = "${var.root_user}"
    root_passwd = "${var.root_passwd}"
  }
}

data "template_file" "userdata_sh" {
  template = "${file("${path.module}/userdata.sh")}"
  vars = {
    ssh_group   = "${var.ssh_group}"
    sudo_group  = "${var.sudo_group}"
    root_user   = "${var.root_user}"
    root_passwd = "${var.root_passwd}"
  }
}

data "template_cloudinit_config" "userdata_multipart" {
  gzip          = "false"
  base64_encode = "true"
  
  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.userdata_tpl.rendered}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_sh.rendered}"
  }
}

module "auto_scaling_lt" {
  providers       = { aws.default = aws.default }
  
  source          = "../../../all_resources/auto_scaling_group/auto_scaling_lt"
  
  asg_lt_name                      = var.asg_lt_name
  asg_lt_disable_api_termination   = var.asg_lt_disable_api_termination
  asg_lt_ami_id                    = "${data.aws_ami.ami_filter.id}"
  asg_lt_instance_type             = var.asg_lt_instance_type
  asg_lt_sg_ids                    = ["${data.aws_security_group.sg_filter.id}"]
  # asg_lt_shutdown_behaviour        = var.asg_lt_shutdown_behaviour
  asg_lt_user_data                 = "${data.template_cloudinit_config.userdata_multipart.rendered}"
  asg_lt_ec2_instance_profile      = "${data.aws_iam_role.ec2_profile.id}"
  asg_lt_associate_public_ip       = var.asg_lt_associate_public_ip
  asg_lt_ebs_additional_volumes    = var.asg_lt_ebs_additional_volumes
  asg_lt_delete_on_termination     = var.asg_lt_delete_on_termination
  tags                             = "${merge(var.tags, map("Name", var.asg_lt_name), map("Resource_Name", "ASG-LT"))}"
}