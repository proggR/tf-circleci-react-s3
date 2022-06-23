#  Terraform Codebook: CircleCI Pipeline For Multiple Subdomains/S3 Backed Static Sites With Cloudfront

A template/workflow for the automated deployment (including infrastrusture provisioning) of a static site (originally made for a React app) to AWS S3 with Cloudfront and ACM.

Assumes each static site exists as a separate project folder in the root directory (@TODO: update to make this true).

Once CircleCI config's conditional logic is updated with the folder/subdomain to listen to subrepo changes, all you need to do is define the apex domain and list of desired subdomains in your s3_subdomains tfvar and the books will:

- fetch apex domain (currently assumes domain already in Route53), and any subdomain records required
- request an ACM cert in your region for use with your infrastructure, as well as a us-east-1 cert for use with Cloudfront (@TODO: fix process for subdomain list changes, CF cert becomes a pain/doesn't destroy unless done manually atm afaik)
- provision s3 buckets and necessary iam/cors policies for each subdomain
- provision cloudfront distribution for each subdomain

# @TODO:
- add conditional logic to CircleCI pipeline and test a proper clone of the app and per-project changes/builds
- model simple state management schema and hack together a python script that takes in subdomain, type of deployement (for now S3/Cloudfront is all that's supported but more to come) and creates the necessary terraform/circleci config changes

#  Notes

React App was created with "npx create-react-app my-app".

Circle CI requires a setup of the deployment pipeline via your CircleCI account (repo only contains config files).

Never include your AWS login credentials in your git repo (and/or terraform files)!!
