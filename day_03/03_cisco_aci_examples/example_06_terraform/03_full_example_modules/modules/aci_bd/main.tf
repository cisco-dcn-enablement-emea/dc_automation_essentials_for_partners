terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

# Bridge Domain
resource "aci_bridge_domain" "bd" {
  tenant_dn                 = var.tenant_dn
  name                      = var.name
  arp_flood                 = "yes"
  unicast_route             = var.type == "L3" ? "yes" : "no"
  unk_mac_ucast_act         = var.type == "L3" ? "proxy" : "flood"
  unk_mcast_act             = "flood"
  limit_ip_learn_to_subnets = "yes"

  relation_fv_rs_ctx       = var.vrf_dn
  relation_fv_rs_bd_to_out = var.associated_l3outs_dn
}

resource "aci_subnet" "subnet" {
  count = var.type == "L3" ? 1 : 0

  parent_dn = aci_bridge_domain.bd.id
  ip        = var.ip_addr
  scope     = var.scope
}
