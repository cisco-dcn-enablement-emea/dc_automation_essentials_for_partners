terraform {
  required_version = ">= 1.3.0"
  required_providers {
    cml2 = {
      source  = "registry.terraform.io/ciscodevnet/cml2"
      version = "= 0.5.1"
    }
  }
}

provider "cml2" {
  address     = var.address
  username    = var.username
  password    = var.password
  skip_verify = true
}

resource "cml2_lifecycle" "wks" {
  topology = templatefile(var.topology_name, var.configuration_variables)
  wait     = true
  state    = var.state
}
