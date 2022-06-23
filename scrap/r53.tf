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

#data "aws_acm_certificate_validation" "skunk" {
  #name = [for record in aws_route53_record.skunk : record.fqdn]
#}

# resource "aws_lb_listener" "skunk" {
  # ... other configuration ...

#  certificate_arn = aws_acm_certificate_validation.skunk.certificate_arn
# }
