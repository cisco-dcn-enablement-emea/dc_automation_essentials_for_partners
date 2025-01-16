terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  # Using environment variables for authentication: ACI_URL, ACI_USERNAME, ACI_PASSWORD
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "0.9.0"

  yaml_directories = ["data"]

  manage_access_policies    = false
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = false
  manage_interface_policies = false
  manage_tenants            = false

}
