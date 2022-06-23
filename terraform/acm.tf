resource "aws_acm_certificate" "cloudfront" {
  domain_name               = "${var.apex_domain}"
  validation_method         = "DNS"
  subject_alternative_names = formatlist("%s.${var.apex_domain}", var.s3_subdomains)

  provider = aws.us_east

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "domain" {
  domain_name               = "${var.apex_domain}"
  validation_method         = "DNS"
  subject_alternative_names = formatlist("%s.${var.apex_domain}", var.s3_subdomains)

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
