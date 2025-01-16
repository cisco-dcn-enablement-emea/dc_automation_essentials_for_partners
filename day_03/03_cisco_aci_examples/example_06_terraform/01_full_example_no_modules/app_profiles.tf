### Application Profiles and EPGs

# App Profiles
resource "aci_application_profile" "ap" {
  for_each = var.app_profiles

  name      = each.value.name
  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
}

# App Endpoint Groups
resource "aci_application_epg" "epg" {
  for_each = var.app_epgs

  name         = each.value.name
  name_alias   = each.value.name_alias
  pref_gr_memb = each.value.pref_gr_memb

  application_profile_dn = aci_application_profile.ap[each.value.parent_app_key].id
  relation_fv_rs_bd      = aci_bridge_domain.bd[each.value.relation_bd_key].id

  relation_fv_rs_cons = [for k in each.value.cons_contracts_key : aci_contract.brc[k].id]
  relation_fv_rs_prov = [for k in each.value.prov_contracts_key : aci_contract.brc[k].id]
}

# App Endpoint Group - Domain Association
resource "aci_epg_to_domain" "rsdomatt" {
  for_each = {
    for d in local.app_epg_domains : "${d.epg_key}_${d.domain_name}" => d
  }

  application_epg_dn = aci_application_epg.epg[each.value.epg_key].id
  tdn                = each.value.domain_dn
}

### Locals
locals {
  app_epg_domains = flatten([
    for epg_key, epg_value in var.app_epgs : [
      for dom in epg_value.domains_dn : {
        epg_key     = epg_key
        domain_dn   = dom
        domain_name = split(dom, "/")[length(split(dom, "/"))-1]
      }
    ]
  ])
}
