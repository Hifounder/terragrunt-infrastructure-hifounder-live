# Learn For Terragrunt
此範例完整參考並延伸應用
* [gruntwork-io/terragrunt-infrastructure-live-example](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example)
* [gruntwork-io/terragrunt-infrastructure-modules-example](https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example)

---
## Quick Start

1. 選擇你要的雲(aws / gcp)
2. 以 `aws` 為例，cd 至 `non-prod/aws` 修正 `provider.hcl` TODO 項目
3. 部署 `mysql` 為例，cd 至 `mysql` 於終端機輸入 `terragrunt init`

---
## 專案結構
```
_envcommon      (module編輯)
non-prod        (非正式)      
  |- aws        (雲供應商)
    |- dev      (專案名稱)
      |- mysql  (雲供應服務)
```
---

## 目標
快速建置可用於 AWS or GCP 基礎設施

---
## Terraform
### Terraform 快速理解
* `Provider` - 公有雲供應商 
* `Backend` - 將 State 以 .tfstate 檔案存放
  * 儲存 State 的資料，提供團隊多人協作
  * 提供 State locking，避免多人同時修改

```
安裝依賴 -> 檢驗 plan -> 部署 plan
terraform init -> terraform plan => terraform apply
```

---
## Terragrunt
* [影片快速理解 Terraform 與 Terragrunt 關係](https://www.youtube.com/watch?v=GrFDB0cUv-Q)


### Terragrunt 快速理解
將 Terraform 保持乾淨 任何參數使用變數的方式帶入且快速擴展雲專案
* module - 將某雲供應商模組化，For某司所用
* live - 以變數帶入替換其專案

### 使用專案前置
1. 版本確認
* `terraform version >= 1.1.4`
* `terragrunt version >= v0.36.0`
2. 修改專案之 hcl 檔案 for 個人


```
安裝依賴 -> 檢驗 plan -> 部署 plan
terragrunt init -> terragrunt plan => terragrunt apply
```

## 解析 根目錄的 `terrafrunt.hcl`

```tf=
# -----------------------------------------------------------------------------
# Terragrunt 設定檔
# -----------------------------------------------------------------------------

locals {
  ... omit
}
# -----------------------------------------------------------------------------
# terraform 的 root module 內產生 provider.tf
# -----------------------------------------------------------------------------

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# -----------------------------------------------------------------------------
# terraform 的 root module 內產生 backend.tf
# 狀態會存置 s3 以便日後組織內部人員更改時，以最新更改狀態理解
# -----------------------------------------------------------------------------

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt        = true
    bucket         = "${local.environment}-${local.profile}-${local.region}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.default_region
    dynamodb_table = "terraform-locks"
  }
}
# -----------------------------------------------------------------------------
# 全局配置，會自動配置於子 `terragrunt.hcl` 設定中
# -----------------------------------------------------------------------------

inputs = {
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
}
```