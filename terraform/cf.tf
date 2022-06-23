resource "aws_cloudfront_distribution" "frontend_cloudfront_distribution" {
  count = length(var.s3_subdomains)
  origin {
    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      #origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = ["SSLv3","TLSv1.2"]
    }
    domain_name = "${aws_s3_bucket.website[count.index].bucket_regional_domain_name}"
    #domain_name = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    #domain_name = "${var.application_subdomain}.s3.amazonaws.com"
    #domain_name = "${aws_s3_bucket.website.bucket}"
    #origin_id = "${var.application_subdomain}"
    origin_id = "${var.s3_subdomains[count.index]}.${var.apex_domain}"
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET","HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id = "${var.s3_subdomains[count.index]}.${var.apex_domain}"
    #target_origin_id = "${var.application_subdomain}"
    #target_origin_id = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    min_ttl = 0
    default_ttl = 0
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

  aliases = ["${var.s3_subdomains[count.index]}.${var.apex_domain}"]
  #aliases = ["${var.application_subdomain}"]

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
