locals {
  region = "ap-northeast-1"
  account_id = "" # TODO: replace me with your AWS account ID!
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}