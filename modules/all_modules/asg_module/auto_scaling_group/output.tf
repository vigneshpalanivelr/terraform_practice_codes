output "asg_id"                { value = module.auto_scaling_group.asg_id                 }
output "asg_arn"               { value = module.auto_scaling_group.asg_arn                }
output "asg_azs"               { value = module.auto_scaling_group.asg_azs                }
output "asg_min_size"          { value = module.auto_scaling_group.asg_min_size           }
output "asg_max_size"          { value = module.auto_scaling_group.asg_max_size           }
output "asg_name"              { value = module.auto_scaling_group.asg_name               }
output "asg_health_check_type" { value = module.auto_scaling_group.asg_health_check_type  }
output "asg_desired_capacity"  { value = module.auto_scaling_group.asg_desired_capacity   }