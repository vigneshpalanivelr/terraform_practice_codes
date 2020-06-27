data "aws_lb_target_group" "tg_filter" {
  provider = aws.default
  name     = "${var.lb_tg_name}"
}

data "aws_instance" "eni_filter" {
  provider = aws.default
  filter {
    name   = "tag:Name"
    values = [ var.ec2_name ]
  }
}

module "aws_elb_tg_attach_module" {
  providers     = { aws.default = aws.default }
  source        = "../../../all_resources/load_balancer_tg_attachment/"

  target_group_arn = data.aws_lb_target_group.tg_filter.arn
  target_id        = data.aws_instance.eni_filter.id
  port             = var.lb_tg_port
}
