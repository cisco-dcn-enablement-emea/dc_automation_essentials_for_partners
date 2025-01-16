# Configure provider with your Cisco ACI credentials
provider "aci" {
  url      = var.aci_url
  username = var.aci_username
  password = var.aci_password
  insecure = true
}

# Provider variables
variable "aci_url" {}
variable "aci_username" {}
variable "aci_password" {}
