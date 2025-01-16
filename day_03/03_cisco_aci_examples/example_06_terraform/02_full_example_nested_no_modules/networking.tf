### Locals

locals {
  vrfs = flatten([
    for tn_key, tn_value in var.tenants : [
      for vrf_key, vrf_value in tn_value.vrfs : {
        parent_tn_key = tn_key
        vrf_key = vrf_key
        vrf = vrf_value
      }
    ]
  ])

  bds = flatten([
    for tn_key, tn_value in var.tenants : [
      for bd_key, bd_value in tn_value.bridge_domains : {
        parent_tn_key = tn_key
        bd_key = bd_key
        bd = bd_value
      }
    ]
  ])
}

### Networking Definition

# VRF
resource "aci_vrf" "vrf" {
  for_each = {
    for item in local.vrfs : item.vrf_key => item 
  }

  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
  name      = each.value.vrf.name
}

# VRF - vzAny
resource "aci_any" "vzany" {
  for_each = {
    for item in local.vrfs : item.vrf_key => item 
  }

  vrf_dn       = aci_vrf.vrf[each.key].id
  pref_gr_memb = each.value.vrf.pref_gr

  relation_vz_rs_any_to_cons = [for k in each.value.vrf.vzany.cons_contracts_key : aci_contract.brc[k].id]
  relation_vz_rs_any_to_prov = [for k in each.value.vrf.vzany.prov_contracts_key : aci_contract.brc[k].id]
}

# Bridge Domain
resource "aci_bridge_domain" "bd" {
  for_each = {
    for item in local.bds : item.bd_key => item
  }

  tenant_dn          = aci_tenant.tn[each.value.parent_tn_key].id
  name               = each.value.bd.name
  arp_flood          = "yes"
  unicast_route      = each.value.bd.type == "L3" ? "yes" : "no"
  unk_mac_ucast_act  = each.value.bd.type == "L3" ? "proxy" : "flood"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.vrf[each.value.bd.relation_vrf_key].id
  relation_fv_rs_bd_to_out = each.value.bd.associated_l3outs_dn
}

resource "aci_subnet" "subnet" {
  for_each = {
    for item in local.bds : item.bd_key => item if item.bd.type == "L3"
  }

  parent_dn = aci_bridge_domain.bd[each.key].id
  ip        = each.value.bd.ip_addr
  scope     = each.value.bd.scope
}
