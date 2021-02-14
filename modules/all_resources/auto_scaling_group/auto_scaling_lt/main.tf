resource "aws_launch_template" "auto_scaling_lt" {
  name                                 = var.asg_lt_name
  description                          = "${var.asg_lt_name} - Auto Scaling Launch Template"
  disable_api_termination              = var.asg_lt_disable_api_termination
  update_default_version               = var.asg_lt_update_default_version
  image_id                             = var.asg_lt_ami_id
  instance_type                        = var.asg_lt_instance_type
  vpc_security_group_ids               = var.asg_lt_sg_ids
  user_data                            = var.asg_lt_user_data
  tags                                 = var.tags

  dynamic "block_device_mappings" {
    for_each      = [for volume in var.asg_lt_ebs_additional_volumes: {
      device_name             = lookup(volume, "device_name",           "/dev/sda" )
      delete_on_termination   = var.asg_lt_delete_on_termination
      encrypted               = lookup(volume, "encrypted",             false      )
      volume_size             = lookup(volume, "volume_size",           30         )
      volume_type             = lookup(volume, "volume_type",           "gp2"      )
    }]
    content {
      device_name             = block_device_mappings.value.device_name
      ebs {
        delete_on_termination = var.asg_lt_delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
      }
    }
  }
  
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
  
  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }
  
  iam_instance_profile   { 
    name                        = var.asg_lt_ec2_instance_profile
  }
  network_interfaces     { 
    associate_public_ip_address = var.asg_lt_associate_public_ip
    delete_on_termination       = var.asg_lt_delete_on_termination
    security_groups             = var.asg_lt_sg_ids
  }
}