locals {
  project  = "" # TODO: replace me with your GCP account ID!
  region   = "asia-east1"
  zone     = "asia-east1-b"
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project}"
  region = "${local.region}"
  zone = "${local.zone}"
}
EOF
}