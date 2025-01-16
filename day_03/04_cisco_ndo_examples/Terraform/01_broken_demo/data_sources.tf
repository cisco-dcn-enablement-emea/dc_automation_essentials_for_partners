# NDO Sites
data "mso_site" "site1" {
  name = var.site1
}

data "mso_site" "site2" {
  name = var.site2
}

# NDO Users
data "mso_user" "current_user" {
  username = var.mso_username
}