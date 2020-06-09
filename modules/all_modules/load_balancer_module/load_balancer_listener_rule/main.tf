data "aws_lb" "lb_filter" {
  provider = aws.default
  name     = var.lb_name
}

data "aws_lb_listener" "listener_filter" {
  provider          = aws.default
  load_balancer_arn = data.aws_lb.lb_filter.arn
  port              = var.lb_port
}

data "aws_lb_target_group" "tg_filter" {
  provider = aws.default
  name     = var.lb_tg_name
}
  
module "aws_elb_lis_rule_module" {
  source                 = "../../../all_resources/load_balancer_listener_rule/"

  listener_arn	= data.aws_lb_listener.listener_filter.arn
  target_dns	= "${var.rule_target_dns}.${var.r53_zone_name}"
  lb_tg_arn		= data.aws_lb_target_group.tg_filter.arn
  response_type = var.rule_response_type
}