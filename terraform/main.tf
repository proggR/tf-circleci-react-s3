# -----------------------------------------------------------------------------
# Define/store secret keys as environment variables in shared credentials file
# -----------------------------------------------------------------------------
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
#

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile = "default"
  region  = var.region
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile = "default"
  alias  = "us_east"
  region = "us-east-1"
}
