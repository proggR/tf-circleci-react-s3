#  Terraform Monorepo: CircleCI Pipeline For Multiple Subdomains/S3 Backed Static Sites With Cloudfront

A template/workflow for the automated deployment (including infrastrusture provisioning) of a static site (originally made for a React app) to AWS S3 with Cloudfront and ACM implemented in a monorepo pattern.

Assumes each static site exists as a separate project folder in the /apps folder of the root directory. Also currently only tested with React apps, but anything that uses `yarn build` to export to a `builds/` directory should in theory work, and CircleCI jobs can be added/triggered as needed.

Once CircleCI config's conditional logic is updated with the subdomain based matching trigger params/workflow combo to listen to subrepo changes, all you need to do is define the apex domain and list of desired subdomains in your `apex_domain` and `s3_subdomains` tfvars respectively and the books will:

- fetch apex domain (currently assumes domain already in Route53), and configures any subdomain records required
- request an ACM cert in your region for use with your infrastructure, as well as a us-east-1 cert for use with Cloudfront , CF cert becomes a pain/doesn't destroy unless done manually atm afaik)
- provision s3 buckets and necessary iam/cors policies for each subdomain
- provision cloudfront distribution for each subdomain

## Variables

### Terraform: terraform/terraform.tfvars

<pre>
region: 'ca-central-1'
apex_domain = "example.com"
s3_subdomains = ["sub1","sub2"]
apex_subdomain = "sub1" #future feature to alias apex to app
</pre>

### CircleCI: ENV Vars

<pre>
CIRCLE_API
CIRCLE_TOKEN
REPOSITORY_TYPE
CIRCLE_PROJECT_REPONAME
CIRCLE_PROJECT_USERNAME
PROD_AWS_ACCESS_KEY_ID
PROD_AWS_SECRET_ACCESS_KEY
</pre>

### CircleCI: .circlecli/.config_vars.yml (once ./circleci/config_gen.py written)

The CircleCI config doesn't yet support proper variables, requiring some copy pasting per subdomain/app. Once the generator script is written the variables (definited in ./circleci/.config_vars.yml) will be:

<pre>
region: 'ca-central-1'
apex_domain:  'example.com'
react_app_subdomains: ['sub1','sub2']
</pre>

# @TODO:

- make ./circleci/gen_config.py take in region, apex domain + CSV of subdomains and generate the config.yml + terraform.tfvars file (maybe move to project root)
- extend with ECM + Fargate for Flask deployments from monorepo

#  Notes

React App was created with "npx create-react-app my-app".

Circle CI requires a setup of the deployment pipeline via your CircleCI account (repo only contains config files).

Never include your AWS login credentials in your git repo (and/or terraform files)!!
