data "aws_vpc" "vpc_filter" {
  provider = aws.default
  
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc_name]
  }
  state = "available"
}

module "aws_elb_tg_module" {
  providers     = { aws.default = aws.default }
  source        = "../../../all_resources/load_balancer_tg/"

  name                   = var.lb_tg_name
  port                   = var.lb_tg_port
  protocol               = var.lb_tg_protocol
  target_type            = var.lb_tg_target_type
  vpc_id                 = data.aws_vpc.vpc_filter.id
  deregistration_delay   = var.lb_tg_deregistration_delay
  tags                   = var.tags
}
