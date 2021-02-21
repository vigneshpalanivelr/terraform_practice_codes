resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  # availability_zones        = var.asg_availability_zones
  launch_template {
    id      = var.asg_launch_template
  }
  
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  initial_lifecycle_hook    = var.asg_initial_lifecycle_hook
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity
  termination_policies      = var.asg_termination_policies
  tags                      = var.asg_tags
  force_delete              = var.asg_force_delete
}