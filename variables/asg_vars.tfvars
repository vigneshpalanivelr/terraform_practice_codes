# ASG Details
asg_force_delete                = true
asg_lt_delete_on_termination    = true
asg_lt_disable_api_termination  = true
asg_lt_associate_public_ip      = true
ec2_instance_profile_name       = "ec2_instance_profile"
ami_root_device_type            = "ebs"
ami_virtualization_type         = "hvm"
ssh_group                       = "root_group"
sudo_group                      = "root_group"

asg_lt_ebs_additional_volumes   = [
    {
    device_name           = "/dev/sda"
    encrypted             = "false"
    volume_size           = "1"
    volume_type           = "gp2"
    },{
    device_name           = "/dev/sdb"
    encrypted             = "false"
    volume_size           = "1"
    volume_type           = "gp2"
    }
]