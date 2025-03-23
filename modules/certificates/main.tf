data "aws_route53_zone" "main" {
  name         = "bagishbek.com"
  private_zone = false
}

resource "aws_acm_certificate" "main" {
  domain_name               = var.domain_names[0]
  subject_alternative_names = slice(var.domain_names, 1, length(var.domain_names))
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 Validation Records
resource "aws_route53_record" "cert_validation" {
  for_each = toset(var.domain_names)

  zone_id = data.aws_route53_zone.main.zone_id

  name    = [for dvo in aws_acm_certificate.main.domain_validation_options : dvo.resource_record_name if dvo.domain_name == each.key][0]
  type    = [for dvo in aws_acm_certificate.main.domain_validation_options : dvo.resource_record_type if dvo.domain_name == each.key][0]
  records = [[for dvo in aws_acm_certificate.main.domain_validation_options : dvo.resource_record_value if dvo.domain_name == each.key][0]]
  ttl     = 60
}

# Wait for ACM validation before proceeding
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "petstore.bagishbek.com"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
