### Locals
locals {
  apps = flatten([
    for tn_key, tn_value in var.tenants : [
      for app_key, app_value in tn_value.app_profiles : {
        parent_tn_key = tn_key
        app_key       = app_key
        app           = app_value
      }
    ]
  ])

  epgs = flatten([
    for tn_key, tn_value in var.tenants : [
      for app_key, app_value in tn_value.app_profiles : [
        for epg_key, epg_value in app_value.epgs : {
          parent_app_key = app_key
          epg_key        = epg_key
          epg            = epg_value
        }
      ]
    ]
  ])

  app_epg_domains = flatten([
    for tn_key, tn_value in var.tenants : [
      for app_key, app_value in tn_value.app_profiles : [
        for epg_key, epg_value in app_value.epgs : [
          for dom in epg_value.domains_dn : {
            epg_key     = epg_key
            domain_dn   = dom
            domain_name = split(dom, "/")[length(split(dom, "/")) - 1]
          }
        ]
      ]
    ]
  ])
}

### Application Profiles and EPGs

# App Profiles
resource "aci_application_profile" "ap" {
  for_each = {
    for item in local.apps : item.app_key => item
  }

  name      = each.value.app.name
  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
}

# App Endpoint Groups
resource "aci_application_epg" "epg" {
  for_each = {
    for item in local.epgs : item.epg_key => item
  }

  name         = each.value.epg.name
  name_alias   = each.value.epg.name_alias
  pref_gr_memb = each.value.epg.pref_gr_memb

  application_profile_dn = aci_application_profile.ap[each.value.parent_app_key].id
  relation_fv_rs_bd      = aci_bridge_domain.bd[each.value.epg.relation_bd_key].id

  relation_fv_rs_cons = [for k in each.value.epg.cons_contracts_key : aci_contract.brc[k].id]
  relation_fv_rs_prov = [for k in each.value.epg.prov_contracts_key : aci_contract.brc[k].id]
}

# App Endpoint Group - Domain Association
resource "aci_epg_to_domain" "rsdomatt" {
  for_each = {
    for d in local.app_epg_domains : "${d.epg_key}_${d.domain_name}" => d
  }

  application_epg_dn = aci_application_epg.epg[each.value.epg_key].id
  tdn                = each.value.domain_dn
}

