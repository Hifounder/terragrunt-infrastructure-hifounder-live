terraform {
  source = "${local.base_source_url}?ref=${local.ref}"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env              = local.environment_vars.locals.environment
  ref              = local.environment_vars.locals.ref
  base_source_url  = local.environment_vars.locals.base_source_url
}


# ------------------
# MODULE PARAMETERS
# ------------------
inputs = {
  name              = "mysql_${local.env}"
  instance_class    = "db.t2.micro"         # TODO: aws:"db.t2.micro" | gcp:"db-f1-micro"
  allocated_storage = 20
  storage_type      = "standard"            # TODO: aws:"standard" | gcp:"PD_SSD"
  master_username   = "admin"
}