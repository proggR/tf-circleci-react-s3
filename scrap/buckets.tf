#  cors_rule {
#    allowed_headers = ["*"]
#    allowed_methods = ["PUT","POST"]
#    allowed_origins = ["*"]
#    expose_headers = ["ETag"]
#    max_age_seconds = 3000
#  }

# policy = "${file("s3_policy.json")}"



    #     lifecycle {
    #
    #         # Any Terraform plan that includes a destroy of this resource will
    #         # result in an error message.
    #         #
    #         prevent_destroy = true
    #     }


<<EOF
{
"Version": "2008-10-17",
"Statement": [
  {
    "Sid": "PublicReadForGetBucketObjects",
    "Effect": "Allow",
    "Principal": {
      "AWS": "*"
    },
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.application_subdomain}/*"
  }
]
}
EOF



# AWS S3 bucket for www-redirect
#resource "aws_s3_bucket" "website_redirect" {
#  bucket = "${var.application_subdomain}"
#  acl = "public-read"
#  force_destroy = true
#
#  website {
#    redirect_all_requests_to = var.application_subdomain
#  }
#
    #     lifecycle {
    #
    #         # Any Terraform plan that includes a destroy of this resource will
    #         # result in an error message.
    #         #
    #         prevent_destroy = true
    #     }
#
#}
