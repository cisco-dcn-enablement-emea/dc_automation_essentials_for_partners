# Remote data sources - Old way, no longer recommended by Hashicorp
# data "terraform_remote_state" "prod-networks" {
#   backend = "remote"

#   config = {
#     organization = "spain-cn-lab"
#     workspaces = {
#       name = "adealdag-iac-demo-networks"
#     }
#   }
# }

data "tfe_outputs" "prod-networks" {
  organization = "spain-cn-lab"
  workspace    = "adealdag-hcp-demo-networks"
}
