resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  # availability_zones        = var.asg_availability_zones
  launch_template {
    id      = var.asg_launch_template
  }
  
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity
  termination_policies      = var.asg_termination_policies
  tags                      = var.asg_tags
  force_delete              = var.asg_force_delete
}