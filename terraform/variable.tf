# AWS region
variable "website_aws_region" {
  default = "ca-central-1"
}

# root level domain
variable "root_domain_name" {
  default = "skunk.services"
}
# apex to sub mapping
variable "apex_subdomain" {
  default = "basic-ci.skunk.services"
}

# subdomains requiring S3 buckets and ACM certs
variable "s3_subdomains" {
  description = "List of deployed subdomains"
  type = list(string)
  default = ["basic-ci.#{root_domain_name}"]
}
