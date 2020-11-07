# EC2 AMI Details
ec2_ami_id                                  = "ami-006b2db4ca7e39d7d"

# EC2 Advanced Options
ec2_instance_type                           = "t2.micro"
ec2_ebs_optimized                           = false
ec2_monitoring                              = false

# EC2 Termination & Shutdown 
ec2_disable_api_termination                 = false
ec2_instance_initiated_shutdown_behavior    = "stop"

# EC2 Root Volume Details
ec2_root_volume_delete_on_termination       = true
ec2_root_volume_iops                        = 0
ec2_root_volume_size                        = 10
ec2_root_volume_type                        = "gp2"

# User Data Variables (comma separated value)
ssh_group                                   = "root_group"
sudo_group                                  = "root_group"
