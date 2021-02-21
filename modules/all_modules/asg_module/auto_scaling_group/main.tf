data "aws_launch_template" "test-asg-lt" {
  filter {
    name   = "launch-template-name"
    values = ["test-asg-lt"]
  }
}

module "auto_scaling_group" {
  providers       = { aws.default = aws.default }
  
  source          = "../../../all_resources/auto_scaling_group/auto_scaling_group"
  
  asg_name                      = var.asg_name
  asg_max_size                  = var.asg_max_size
  asg_min_size                  = var.asg_min_size
  asg_desired_capacity          = "${length(var.asg_desired_capacity) > 0 ? var.asg_desired_capacity : var.min_size}"
  # asg_availability_zones        = var.asg_availability_zones
  asg_launch_template           = "${data.aws_launch_template.test-asg-lt.id}"
  asg_initial_lifecycle_hook    = var.asg_initial_lifecycle_hook
  asg_health_check_type         = var.asg_health_check_type
  asg_termination_policies      = ["OldestLaunchConfiguration", "OldestLaunchTemplate", "OldestInstance"]
  asg_tags                      = "${merge(var.tags, map("Name", var.asg_name), map("Resource_Name", "ASG"))}"
  asg_force_delete              = "${var.asg_force_delete}"
}