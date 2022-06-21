# AWS region
variable "website_aws_region" {
  default = "ca-central-1"
}

# root level domain
variable "root_domain_name" {
  default = "skunk.services"
}
# website name without preceeding www.
variable "application_subdomain" {
  default = "basic-ci.skunk.services"
}

# AWS access key
variable "access_key" {
}
# AWS secret key
variable "secret_key" {
}
