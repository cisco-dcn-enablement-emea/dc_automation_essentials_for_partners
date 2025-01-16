terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 2.15.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.62.0"
    }
  }
  required_version = ">= 0.13"
}
