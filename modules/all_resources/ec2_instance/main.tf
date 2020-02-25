resource "aws_instance" "ec2_instance" {
  ami                                  = "${var.ami}"
  availability_zone                    = "${var.availability_zone}"
  ebs_optimized                        = "${var.ebs_optimized}"
  disable_api_termination              = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  instance_type                        = "${var.instance_type}"
  monitoring                           = "${var.monitoring}"
  #  vpc_security_group_ids               = "${var.vpc_security_group_ids}"
  #  subnet_id                            = "${var.subnet_id}"
  iam_instance_profile                 = "${var.iam_instance_profile}"
  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    iops                  = "${var.iops}"
    delete_on_termination = "${var.delete_on_termination}"
  }
  network_interface {
    device_index          = 0
    network_interface_id  = "${var.network_interface_id}"
    delete_on_termination = false
  }
  tags                                 = "${merge(var.tags, map("Name", var.ec2_instance_name), map("Resource_Name","EC2"))}"
  volume_tags                          = "${merge(var.tags, map("Name", "${var.ec2_instance_name}-root"), map("Resource_Name","EBS"))}"
  user_data			       = "${var.userdata}"
}
