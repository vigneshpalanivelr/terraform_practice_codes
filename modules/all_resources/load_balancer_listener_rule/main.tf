resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = var.listener_arn
  
  condition {
    host_header {
      values = [ var.target_dns ]
    }
  }

  action {
    type              = var.response_type
    target_group_arn  = var.lb_tg_arn
    
    fixed_response {
      content_type = "text/plain"
      message_body = "--------------------------- Please contact DevOps Team ---------------------------"
      status_code  = "503"
    }

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}