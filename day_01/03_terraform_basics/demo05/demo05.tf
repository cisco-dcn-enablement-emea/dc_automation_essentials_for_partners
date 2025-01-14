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
  unicast_route      = each.value.type == "L3" ? "yes" : "no"
  unk_mac_ucast_act  = each.value.type == "L3" ? "proxy" : "flood"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.main.id
}

resource "aci_subnet" "net" {
  for_each = { for k, v in var.bridge_domains : k => v if v.type == "L3" }

  parent_dn = aci_bridge_domain.bd[each.key].id
  ip        = each.value.gateway
  scope     = each.value.scope
}

data "aci_l3_domain_profile" "core_l3dom" {
  name = "core_l3dom"
}

module "l3out_core" {
  source = "./modules/aci_l3out"

  tenant_id        = aci_tenant.demo.id
  name             = "core_l3out"
  vrf_id           = aci_vrf.main.id
  l3_ext_domain_id = data.aci_l3_domain_profile.core_l3dom.id
  nodes = {
    103 = {
      pod_id          = "1"
      node_id         = "103"
      rtr_id          = "51.1.1.1"
      rtr_id_loopback = "no"
    }
  }
  paths = {
    "103.1.19" = {
      pod_id  = "1"
      node_id = "103"
      port_id = "eth1/19"
      ip_addr = "5.5.1.2/24"
      mode    = "regular"
      mtu     = "inherit"
    }
  }
  bgp_peers = {
    asa = {
      peer_addr = "5.5.1.1"
      peer_asn  = "65099"
      local_asn = "65001"
    }
  }
  external_epgs = {
    default = {
      name               = "default_l3epg"
      prefGrp            = "exclude"
      provided_contracts = ["default"]
      consumed_contracts = []
      subnets = {
        "0.0.0.0" = {
          ip    = "0.0.0.0/0"
          scope = ["import-security"]
        }
      }
    }
  }
}
