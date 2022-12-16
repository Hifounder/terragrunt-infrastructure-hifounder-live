# non-prod
非正式環境，環境快速建置專案


## 如何使用
### Deploy a modules in a region - 部署單一模塊於單一地域 
Example: mysql
1. `cd aws/dev/mysql`
2. `terragrunt plan` 檢查配置
3. 如果配置不錯，可執行`terragrunt apply` 

### Deploy all modules in a region - 部署全部模塊於單一地域 
1. `cd aws`
2. `terragrunt plan-all` 檢查配置
3. 如果配置不錯，可執行`terragrunt apply-all` 

### Deplay form own moudle
記得分兩個專案資料夾：
1. `live`
2. `module`

可用 aws 範例 [module](https://github.com/Hifounder/terragrunt-infrastructure-aws-modules)
```zsh
$ git clone git@github.com:Hifounder/terragrunt-infrastructure-aws-modules.git
$ terragrunt init --terragrunt-source ~/Developer/github/hifounder/terragrunt-infrastructure-aws-modules//mysql/
```