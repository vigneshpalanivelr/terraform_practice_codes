data "aws_vpc" "vpc_filter" {
  provider = aws.default
  
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc_name]
  }
  state = "available"
}

data "aws_security_group" "sg_filter" {
  provider = aws.default
  
  name     = "${var.sg_group_name}-sg"
  vpc_id   = data.aws_vpc.vpc_filter.id
}

data "aws_subnet" "filter_subnet" {
  provider = aws.default
  count    = var.az_count
  
  filter {
    name   = "tag:Name"
    values = ["default-subnet-${count.index + 1}"]
  }
}

/*
data "aws_acm_certificate" "acm_filter" {
  most_recent = true
  domain_name = "*.${var.r53_zone_name}"
  types       = ["AMAZON_ISSUED"]
}
*/

module "aws_elb_module" {
  source                 = "../../../all_resources/load_balancer/"

  lb_name                = var.lb_name
  lb_type                = var.lb_type
  lb_is_internal         = var.lb_is_internal
  lb_security_group_ids  = [data.aws_security_group.sg_filter.id]
  subnet_ids             = data.aws_subnet.filter_subnet.*.id
  tags                   = var.tags
}
