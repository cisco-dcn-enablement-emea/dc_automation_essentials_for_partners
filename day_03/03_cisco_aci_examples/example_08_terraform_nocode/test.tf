terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.15.0"
    }
  }
}

provider "aci" {
  # Credentials will be provided as environment variables
}

module "test" {
  source               = "./modules/aci_project"
  tenant_name          = "terraform_nocode_demo"
  vrf_name             = "demo_vrf"
  project_name         = "project_ruby"
  project_subnet       = "10.10.10.1/24"
  project_subnet_scope = "public"
  project_open_ports   = ["80", "443"]
}
