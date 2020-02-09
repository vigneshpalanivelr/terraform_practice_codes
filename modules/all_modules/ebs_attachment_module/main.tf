terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_num}:role/${var.assume_role}"
  }
}

# data source from TF file for EBS
data "terraform_remote_state" "ebs_filter" {
  backend = "s3"
  config  = {
    region = "${var.aws_region}"
    bucket = "${var.s3_backend_bucket}"
    key    = "${var.ebs_key_state_prefix}/${var.resource_name}-ebs-volumes.tfstate"
  }
}


data "aws_instance" "ec2_filter" {
  filter {
    name   = "tag:Name"
    values = ["${var.resource_name}"]
  }
}

module "aws_ebs_volume_attachment" {
  source            = "../../all_resources/ebs_volume_attachment/"
  ebs_volume_count  = "${var.ebs_volume_count}"
  volume_id	    = "${data.terraform_remote_state.ebs_filter.outputs.vol_id}"
  instance_id       = "${data.aws_instance.ec2_filter.id}"
  ebs_device_names  = "${var.ebs_device_names}"
}
