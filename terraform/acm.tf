resource "aws_acm_certificate" "skunk" {
  domain_name               = "skunk.services"
  validation_method         = "DNS"
}

resource "aws_route53_zone" "skunk_test" {
  name         = "basic-ci.skunk.services"
  # private_zone = false
}

resource "aws_route53_zone" "skunk_exclaim" {
  name         = "exclaim-ci.skunk.services"
  # private_zone = false
}

resource "aws_route53_record" "skunk" {
  for_each = {
    for dvo in aws_acm_certificate.skunk.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == "exclaim-ci.skunk.services" ? aws_route53_zone.skunk_exclaim.zone_id : aws_route53_zone.skunk_test.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "skunk" {
  certificate_arn         = aws_acm_certificate.skunk.arn
  validation_record_fqdns = [for record in aws_route53_record.skunk : record.fqdn]
}

# resource "aws_lb_listener" "skunk" {
  # ... other configuration ...

#  certificate_arn = aws_acm_certificate_validation.skunk.certificate_arn
# }


resource "aws_cloudfront_distribution" "frontend_cloudfront_distribution" {
  origin {
    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1","TLSv1.1","TLSv1.2"]
    }
    domain_name = "${aws_s3_bucket.website.bucket}"
    origin_id = "${var.application_subdomain}"
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET","HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id = "{$var.application_subdomain}"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
   error_caching_min_ttl = 3000
   error_code = 404
   response_code = 200
   response_page_path = "/index.html"
  }

  aliases = ["${var.application_subdomain}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.skunk.arn
    ssl_support_method = "sni-only"
  }
}
