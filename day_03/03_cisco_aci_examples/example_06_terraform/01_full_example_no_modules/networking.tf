### Networking Definition

# VRF
resource "aci_vrf" "vrf" {
  for_each = var.vrfs

  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
  name      = each.value.name
}

# VRF - vzAny
resource "aci_any" "vzany" {
  for_each = var.vrfs

  vrf_dn       = aci_vrf.vrf[each.key].id
  pref_gr_memb = each.value.pref_gr

  relation_vz_rs_any_to_cons = [for k in each.value.vzany.cons_contracts_key : aci_contract.brc[k].id]
  relation_vz_rs_any_to_prov = [for k in each.value.vzany.prov_contracts_key : aci_contract.brc[k].id]
}

# Bridge Domain
resource "aci_bridge_domain" "bd" {
  for_each = var.bridge_domains

  tenant_dn          = aci_tenant.tn[each.value.parent_tn_key].id
  name               = each.value.name
  arp_flood          = "yes"
  unicast_route      = each.value.type == "L3" ? "yes" : "no"
  unk_mac_ucast_act  = each.value.type == "L3" ? "proxy" : "flood"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.vrf[each.value.relation_vrf_key].id
  relation_fv_rs_bd_to_out = each.value.associated_l3outs_dn
}

resource "aci_subnet" "subnet" {
  for_each = {
    for k, v in var.bridge_domains : k => v if v.type == "L3"
  }

  parent_dn = aci_bridge_domain.bd[each.key].id
  ip        = each.value.ip_addr
  scope     = each.value.scope
}
