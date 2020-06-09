data "aws_lb" "lb_filter" {
  provider = aws.default
  name     = var.lb_name
}

module "lb_listener" {
  providers     = { aws.default = aws.default }
  source        = "../../../all_resources/load_balancer_listener"

  arn               = data.aws_lb.lb_filter.arn
  port              = var.lb_port
  protocol          = var.lb_protocol
  response_type     = var.lb_response_type
}