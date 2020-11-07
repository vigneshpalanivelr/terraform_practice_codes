#data filter for AWS VPC
data "aws_vpc" "vpc_filter" {
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc_name]
  }
  state = "available"
}

#resource for SG
resource "aws_security_group" "sg_demo" {
  name = "${var.ec2_instance_name}-sg"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#data filters for VPC Subnet
data "aws_subnet" "filter_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_subnet_name]
  }
}


#Template file for userdata script
data "template_file" "userdata_sh" {
  template = "${file("${path.module}/userdata.sh")}"
  vars = {
    ssh_group   = var.ssh_group
    sudo_group  = var.sudo_group
    root_user   = var.root_user
    root_passwd = var.root_passwd
  }
}

#Cloudconfig template to include in userdata
data "template_cloudinit_config" "userdata_multipart" {
  gzip          = "false"
  base64_encode = "false"

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata_sh.rendered
  }
}

#module for the instances
module "aws_ec2_module" {
  source                               = "../../all_resources/ec2_instance/"
  count_ec2                            = 3
  ami                                  = var.ec2_ami_id
  ec2_instance_name                    = var.ec2_instance_name
  availability_zone                    = var.ec2_az
  ebs_optimized                        = var.ec2_ebs_optimized
  disable_api_termination              = var.ec2_disable_api_termination
  instance_initiated_shutdown_behavior = var.ec2_instance_initiated_shutdown_behavior
  instance_type                        = var.ec2_instance_type
  monitoring                           = var.ec2_monitoring
  tags                                 = var.tags
  volume_type                          = var.ec2_root_volume_type
  volume_size                          = var.ec2_root_volume_size
  iops                                 = var.ec2_root_volume_iops
  delete_on_termination                = var.ec2_root_volume_delete_on_termination
  userdata                             = data.template_cloudinit_config.userdata_multipart.rendered
  vpc_security_group_ids               = [aws_security_group.sg_demo.id]
}

resource "null_resource" "ansible-deploy" {
  provisioner "local-exec" {
  command = <<EOT
    cd ansible; sleep 240;
    ansible-playbook -i inventory  site.yml --extra-vars "ansible_user=$user ansible_ssh_pass=$pass" --tags=install_haproxy --tags=install_httpd
  EOT
  environment = {
      user = var.root_user
      pass = var.root_passwd
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
  depends_on = [module.aws_ec2_module]
}
