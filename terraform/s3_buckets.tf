# AWS S3 bucket for static hosting

# AWS main domain bucket (file storage)
resource "aws_s3_bucket" "website" {
  bucket = var.application_subdomain
  force_destroy = true

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
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.website.bucket
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.website.arn,
      "arn:aws:s3:::${var.application_subdomain}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

#  routing_rule {
#    condition {
#      key_prefix_equals = "docs/"
#    }
#    redirect {
#      replace_key_prefix_with = "documents/"
#    }
#  }
}


resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://basic-ci.skunk.services"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

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
