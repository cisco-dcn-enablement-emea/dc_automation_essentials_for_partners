terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.62.0"
    }
  }
  required_version = ">= 0.13"
}
