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
