output "aws_route53_zone_id" { value = aws_route53_zone.private_hosted_zone.id }
output "aws_route53_zone_name_servers" { value = aws_route53_zone.private_hosted_zone.name_servers }
