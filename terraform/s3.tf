# AWS S3 bucket for static hosting

# AWS main domain bucket (file storage)
resource "aws_s3_bucket" "website" {
  count = length(var.s3_subdomains)
  bucket = "${var.s3_subdomains[count.index]}.${var.apex_domain}"
  #bucket = var.application_subdomain
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count = length(var.s3_subdomains)
  bucket = aws_s3_bucket.website[count.index].bucket
  #bucket = aws_s3_bucket.website.bucket
  policy = data.aws_iam_policy_document.allow_access_from_another_account[count.index].json
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  count = length(var.s3_subdomains)
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
      #aws_s3_bucket.website.arn,
      aws_s3_bucket.website[count.index].arn,
      #"arn:aws:s3:::${var.application_subdomain}/*",
      "arn:aws:s3:::${var.s3_subdomains[count.index]}.${var.apex_domain}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  count = length(var.s3_subdomains)
  bucket = aws_s3_bucket.website[count.index].bucket
  #bucket = aws_s3_bucket.website.bucket

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
  count = length(var.s3_subdomains)
  bucket = aws_s3_bucket.website[count.index].bucket
  #bucket = aws_s3_bucket.website.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "website" {
  count = length(var.s3_subdomains)
  bucket = aws_s3_bucket.website[count.index].bucket
  #bucket = aws_s3_bucket.website.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["${var.s3_subdomains[count.index]}.${var.apex_domain}"]    
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
