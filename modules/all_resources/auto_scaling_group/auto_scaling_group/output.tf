output "asg_id"                { value = aws_autoscaling_group.asg.id                 }
output "asg_arn"               { value = aws_autoscaling_group.asg.arn                }
output "asg_azs"               { value = aws_autoscaling_group.asg.availability_zones }
output "asg_min_size"          { value = aws_autoscaling_group.asg.min_size           }
output "asg_max_size"          { value = aws_autoscaling_group.asg.max_size           }
output "asg_desired_capacity"  { value = aws_autoscaling_group.asg.desired_capacity   }
output "asg_name"              { value = aws_autoscaling_group.asg.name               }
output "asg_health_check_type" { value = aws_autoscaling_group.asg.health_check_type  }
