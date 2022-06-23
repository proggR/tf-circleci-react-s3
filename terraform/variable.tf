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

# apex to sub mapping
variable "apex_subdomain" {
  default = "basic-ci.skunk.services"
}

# exclaim webapp domain
variable "exclaim_subdomain" {
  default = "exclaim-ci.skunk.services"
}
# cms webapp domain
variable "cms_subdomain" {
  default = "cms-ci.skunk.services"
}
# graphql api domain
variable "api_subdomain" {
  default = "gql-ci.skunk.services"
}

# subdomains requiring S3 buckets and ACM certs
variable "subdomains" {
  description = "List of deployed subdomains"
  type = list(string)
  default = ["basic-ci.skunk.services"]
}
