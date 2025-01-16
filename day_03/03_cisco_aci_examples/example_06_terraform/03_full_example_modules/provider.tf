variable "aci_url" {
  type = string
  description = "APIC URL"
}
variable "aci_username" {
  type = string
  description = "APIC username"
  default = "admin"
}
variable "aci_password" {
  type = string
  description = "APIC password"
  sensitive = true
}

provider "aci" {
  url      = var.aci_url
  username = var.aci_username
  password = var.aci_password
  # private_key = "file(/Users/adealdag/.ssh/labadmin.key)"
  # cert_name = "labadmin.crt"
  insecure = true
}