resource "aws_cloudwatch_metric_alarm" "cpu_information" {
  count               = "${length(var.instance_ids)}"
  alarm_name          = "${var.resource_name}-CPUUtilization-info-for-${var.instance_ids[count.index]}-${var.cw_cpu_threshold_info}"
  alarm_description   = "${var.cw_cpu_threshold_info}% CPU Utilization Reached"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  namespace           = "AWS/EC2"
  period              = "${var.cw_cpu_period}"
  statistic           = "Average"
  threshold           = "${var.cw_cpu_threshold_info}"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index]}"
  }
  alarm_actions = ["${var.sns_topic_information}"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_critical" {
  count               = "${length(var.instance_ids)}"
  alarm_name          = "${var.resource_name}-CPUUtilization-alert-for-${var.instance_ids[count.index]}-${var.cw_cpu_threshold_critical}"
  alarm_description   = "${var.cw_cpu_threshold_critical}% CPU Utilization Reached"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  namespace           = "AWS/EC2"
  period              = "${var.cw_cpu_period}"
  statistic           = "Average"
  threshold           = "${var.cw_cpu_threshold_critical}"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index]}"
  }
  alarm_actions = ["${var.sns_topic_information}", "${var.sns_topic_critical}"]
}

resource "aws_cloudwatch_metric_alarm" "disk_space_ebs_critical" {
  count               = "${length(var.instance_ids) * length(var.ebs_devices_list)}"
  alarm_name          = "${var.resource_name}-Disk-Space-alert-for-Instance-${var.instance_ids[count.index % length(var.instance_ids)]}-Volume-${var.ebs_devices_list[count.index % length(var.ebs_devices_list)]}-${var.cw_diskspc_threshold}%"
  alarm_description   = "${var.cw_diskspc_threshold}% Disk Utilization reached"
  metric_name         = "DiskSpaceUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  namespace           = "System/Linux"
  period              = "${var.cw_diskspc_period}"
  statistic           = "Maximum"
  threshold           = "${var.cw_diskspc_threshold}"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index % length(var.instance_ids)]}"
    MountPath  = "${var.ebs_mount_path_list[count.index % length(var.ebs_mount_path_list)]}"
    Filesystem = "${var.ebs_devices_list[count.index % length(var.ebs_devices_list)]}"
  }
  alarm_actions = ["${var.sns_topic_information}"]
}

resource "aws_cloudwatch_metric_alarm" "mem_information" {
  count               = "${length(var.instance_ids)}"
  alarm_name          = "${var.resource_name}-MemoryUtilization-info-for-${var.instance_ids[count.index]}-${var.cw_mem_threshold_info}"
  alarm_description   = "${var.cw_mem_threshold_info}% Memory Utilization Reached"
  metric_name         = "MemoryUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  namespace           = "System/Linux"
  period              = "${var.cw_mem_period}"
  statistic           = "Maximum"
  threshold           = "${var.cw_mem_threshold_info}"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index]}"
  }
  alarm_actions = ["${var.sns_topic_information}"]
}

resource "aws_cloudwatch_metric_alarm" "mem_critical" {
  count               = "${length(var.instance_ids)}"
  alarm_name          = "${var.resource_name}-MemoryUtilization-alert-for-${var.instance_ids[count.index]}-${var.cw_mem_threshold_critical}"
  alarm_description   = "${var.cw_mem_threshold_critical}% Memory Utilization Reached"
  metric_name         = "MemoryUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  namespace           = "System/Linux"
  period              = "${var.cw_mem_period}"
  statistic           = "Maximum"
  threshold           = "${var.cw_mem_threshold_critical}"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index]}"
  }
  alarm_actions = ["${var.sns_topic_information}", "${var.sns_topic_critical}"]
}

resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  count               = "${length(var.instance_ids)}"
  alarm_name          = "${var.resource_name}-StatusCheckFailed-alert-for-${var.instance_ids[count.index]}-ALERT"
  alarm_description   = "Instance status check failure alert"
  metric_name         = "StatusCheckFailed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  namespace           = "AWS/EC2"
  period              = "${var.cw_inst_status_period}"
  statistic           = "Maximum"
  threshold           = "0"
  dimensions = {
    InstanceId = "${var.instance_ids[count.index]}"
  }
  alarm_actions = ["${var.sns_topic_information}", "${var.sns_topic_critical}"]
}
