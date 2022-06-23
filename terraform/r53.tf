data "aws_route53_zone" "apex" {
  name         = "${var.root_domain_name}."
  #private_zone = false
}


resource "aws_route53_record" "frontend_record" {
  count = length(var.s3_subdomains)
  zone_id = data.aws_route53_zone.apex.zone_id
  name = "${var.s3_subdomains[count.index]}"
  #name = "${var.application_subdomain}"
  type = "A"
  alias {
    #name = "${aws_cloudfront_distribution.frontend_cloudfront_distribution.domain_name}"
    #zone_id = "${aws_cloudfront_distribution.frontend_cloudfront_distribution.hosted_zone_id}"
    name = "${aws_cloudfront_distribution.frontend_cloudfront_distribution[count.index].domain_name}"
    zone_id = "${aws_cloudfront_distribution.frontend_cloudfront_distribution[count.index].hosted_zone_id}"
    evaluate_target_health = false
    #zone_id = data.aws_route53_zone.apex.zone_id
  }
}

resource "aws_route53_record" "domain" {
  for_each = {
    for dvo in aws_acm_certificate.domain.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      #zone_id = dvo.domain_name == "exclaim-ci.skunk.services" ? aws_route53_zone.skunk_exclaim.zone_id : dvo.domain_name == "basic-ci.skunk.services" ? aws_route53_zone.skunk_test.zone_id : data.aws_route53_zone.apex.zone_id
      #zone_id = dvo.domain_name == dvo.domain_name == "basic-ci.skunk.services" ? aws_route53_zone.skunk_test.zone_id : data.aws_route53_zone.apex.zone_id
      zone_id = data.aws_route53_zone.apex.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}




#resource "aws_route53_zone" "skunk_test" {
#  name         = "${var.application_subdomain}"
  # private_zone = false
#}
