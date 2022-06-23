resource "aws_acm_certificate" "cloudfront" {
  domain_name               = "${var.root_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = var.subdomains

  provider = aws.us_east

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate" "skunk" {
  domain_name               = "${var.root_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = var.subdomains

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "skunk_test" {
  name         = "${var.application_subdomain}"
  # private_zone = false
}

#resource "aws_route53_record" "test_ns" {
#  zone_id = data.aws_route53_zone.skunk_apex.zone_id
#  name    = "${var.application_subdomain}"
# type    = "NS"
#  ttl     = "30"
#  records = aws_route53_zone.skunk_test.name_servers
#}

#resource "aws_route53_zone" "skunk_exclaim" {
#  name         = "${var.exclaim_subdomain}"
  # private_zone = false
#}

#resource "aws_route53_zone" "skunk_cms" {
#  name         = "${var.cms_subdomain}"
#}

#resource "aws_route53_zone" "skunk_gql" {
#  name         = "${var.gql_subdomain}"
#}

resource "aws_route53_record" "skunk" {
  for_each = {
    for dvo in aws_acm_certificate.skunk.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      #zone_id = dvo.domain_name == "exclaim-ci.skunk.services" ? aws_route53_zone.skunk_exclaim.zone_id : dvo.domain_name == "basic-ci.skunk.services" ? aws_route53_zone.skunk_test.zone_id : data.aws_route53_zone.skunk_apex.zone_id
      #zone_id = dvo.domain_name == dvo.domain_name == "basic-ci.skunk.services" ? aws_route53_zone.skunk_test.zone_id : data.aws_route53_zone.skunk_apex.zone_id
      zone_id = data.aws_route53_zone.skunk_apex.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

#data "aws_acm_certificate_validation" "skunk" {
  #name = [for record in aws_route53_record.skunk : record.fqdn]
#}

resource "aws_acm_certificate_validation" "skunk" {
  certificate_arn         = aws_acm_certificate.skunk.arn
  validation_record_fqdns = [for record in aws_route53_record.skunk : record.fqdn]
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider = aws.us_east
  certificate_arn         = aws_acm_certificate.cloudfront.arn
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
      #origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = ["SSLv3","TLSv1.2"]
    }
    domain_name = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    #domain_name = "${var.application_subdomain}.s3.amazonaws.com"
    #domain_name = "${aws_s3_bucket.website.bucket}"
    origin_id = "${var.application_subdomain}"
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET","HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id = "${var.application_subdomain}"
    #target_origin_id = "${aws_s3_bucket.website.bucket_regional_domain_name}"
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

  aliases = ["${var.root_domain_name}","${var.application_subdomain}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cloudfront.arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method = "sni-only"
  }

  depends_on = [aws_acm_certificate.cloudfront]
}
