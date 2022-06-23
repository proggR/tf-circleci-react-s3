resource "aws_acm_certificate" "cloudfront" {
  domain_name               = "${var.root_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = var.subdomains

  provider = aws.us_east

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "domain" {
  domain_name               = "${var.root_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = var.subdomains

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "domain" {
  certificate_arn         = aws_acm_certificate.domain.arn
  validation_record_fqdns = [for record in aws_route53_record.domain : record.fqdn]
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider = aws.us_east
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.domain : record.fqdn]
}
