# -----------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# -----------------------------------------------------------------------------

locals {
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  provider_vars    = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  name_prefix      = local.common_vars.locals.name_prefix
  default_region   = local.common_vars.locals.default_region
  profile          = local.account_vars.locals.profile
  region           = local.region_vars.locals.region

}

# -----------------------------------------------------------------------------
# GENERATED PROVIDER BLOCK
# -----------------------------------------------------------------------------

generate = local.provider_vars.generate

# -----------------------------------------------------------------------------
# GENERATED REMOTE STATE BLOCK ， THIS STATE USE FOR AWS_S3
# IF STATE USE LOCAL REMOVE THIS BLOCK
# -----------------------------------------------------------------------------

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt        = true
    bucket         = "${local.name_prefix}-${local.profile}-${local.region}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.default_region
    dynamodb_table = "terraform-locks"
  }
}
# -----------------------------------------------------------------------------
# GLOBAL PARAMETERS
# -----------------------------------------------------------------------------

inputs = merge(
  local.common_vars.locals,
  local.provider_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)