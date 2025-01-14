terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 2.0.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aci" {
  # Cisco ACI user name
  username    = "terraform"
  private_key = "../pki/labadmin.key"
  cert_name   = "labadmin.crt"
  url         = "https://apic1-mlg1.cisco.com"
  insecure    = true
}

resource "aci_tenant" "demo" {
  name        = var.tenant_name
  description = "This is a demo tenant created from Terraform"
}

resource "aci_vrf" "main" {
  tenant_dn = aci_tenant.demo.id
  name      = var.vrf_name
}

resource "aci_bridge_domain" "bd" {
  for_each = var.bridge_domains

  tenant_dn          = aci_tenant.demo.id
  name               = each.value.name
  arp_flood          = each.value.arp_flood
  unicast_route      = each.value.unicast_routing
  unk_mac_ucast_act  = each.value.unk_ucast
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.main.id
}
