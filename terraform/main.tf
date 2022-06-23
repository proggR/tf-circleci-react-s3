# -----------------------------------------------------------------------------
# Define/store secret keys as environment variables in shared credentials file
# -----------------------------------------------------------------------------
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
#

provider "aws" {
  #access_key = var.access_key
  #secret_key  = var.secret_key
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile = "default"
  region  = var.website_aws_region
}

provider "aws" {
  #access_key = var.access_key
  #secret_key  = var.secret_key
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile = "default"
  alias  = "us_east"
  region = "us-east-1"
}

resource "aws_route53_record" "frontend_record" {
  zone_id = data.aws_route53_zone.skunk_apex.zone_id
  name = "${var.application_subdomain}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.frontend_cloudfront_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.frontend_cloudfront_distribution.hosted_zone_id}"
    #zone_id = data.aws_route53_zone.skunk_apex.zone_id
    evaluate_target_health = false
  }
}
