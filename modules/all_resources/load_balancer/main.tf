resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  load_balancer_type = var.lb_type
  internal           = var.lb_is_internal
  security_groups    = var.lb_security_group_ids
  
  subnets                            = var.subnet_ids
  enable_cross_zone_load_balancing   = var.lb_type == "network"     ? true : false
  enable_http2                       = var.lb_type == "application" ? true : false
  idle_timeout                       = var.lb_type == "application" ? 60   : ""
  enable_deletion_protection         = true
  
  tags                               = "${merge(var.tags, map("Name", "${var.lb_name}"), map("Resource_Name","Load_Balancer"))}"
  
  /*
  access_logs {
    enabled   = var.lb_log_bucket == "" ? false : true
    bucket    = var.lb_log_bucket
    prefix    = var.lb_log_bucket_prefix
  }
  */
}