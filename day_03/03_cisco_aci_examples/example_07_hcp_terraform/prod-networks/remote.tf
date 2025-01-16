# Remote data sources - Old way, no longer recommended by Hashicorp
# data "terraform_remote_state" "prod-tenant" {
#   backend = "remote"

#   config = {
#     organization = "spain-cn-lab"
#     workspaces = {
#       name = "adealdag-iac-demo-tenant"
#     }
#   }
# }

data "tfe_outputs" "prod-tenant" {
  organization = "spain-cn-lab"
  workspace    = "adealdag-hcp-demo-tenant"
}
