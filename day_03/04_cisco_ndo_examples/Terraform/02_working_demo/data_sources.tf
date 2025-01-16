# NDO Sites
data "mso_site" "site1" {
  name = local.site1_name
}

data "mso_site" "site2" {
  name = local.site2_name
}

# NDO Users
data "mso_user" "current_user" {
  username = var.mso_username
}
