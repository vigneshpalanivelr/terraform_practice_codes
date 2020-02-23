terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

data "aws_instances" "instances_id_list" {
  filter {
    name = "tag:Name"
    values = ["${var.instance_name}"]
  }
}

data "aws_sns_topic" "sns_info" {
  name = "${var.sns_topic_information}"
}

data "aws_sns_topic" "sns_critical" {
  name = "${var.sns_topic_critical}"
}

module "cw_alarm_ec2" {
  source              = "../../../all_resources/cw_alarms/cw_alarms_ec2"
  instance_ids        = "${data.aws_instances.instances_id_list.ids}"

  sns_topic_information = "${data.aws_sns_topic.sns_info.arn}"
  sns_topic_critical    = "${data.aws_sns_topic.sns_critical.arn}"

  cw_cpu_threshold_info     = "${var.cw_cpu_threshold_info}"
  cw_cpu_threshold_critical = "${var.cw_cpu_threshold_critical}"
  cw_cpu_period             = "${var.cw_cpu_period}"

  cw_mem_threshold_info     = "${var.cw_mem_threshold_info}"
  cw_mem_threshold_critical = "${var.cw_mem_threshold_critical}"
  cw_mem_period             = "${var.cw_mem_period}"

  cw_diskspc_threshold = "${var.cw_diskspc_threshold}"
  cw_diskspc_period    = "${var.cw_diskspc_period}"

  ebs_devices_list    = "${var.ebs_devices_list}"
  ebs_mount_path_list = "${var.ebs_mount_path_list}"

  cw_inst_status_period = "${var.cw_inst_status_period}"
  instance_name		= "${var.instance_name}"
}
