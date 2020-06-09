resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type = var.response_type
    
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