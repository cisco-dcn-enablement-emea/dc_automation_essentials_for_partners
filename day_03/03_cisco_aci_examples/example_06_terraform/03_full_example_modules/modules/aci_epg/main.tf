terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

# App Endpoint Groups
resource "aci_application_epg" "epg" {
  name         = var.name
  name_alias   = var.name_alias
  pref_gr_memb = var.pref_gr_memb

  application_profile_dn = var.app_profile_dn
  relation_fv_rs_bd      = var.bridge_domain_dn

  relation_fv_rs_cons = var.cons_contracts_dn
  relation_fv_rs_prov = var.prov_contracts_dn
}

# App Endpoint Group - Domain Association
resource "aci_epg_to_domain" "rsdomatt" {
  for_each = toset(var.associated_domains_dn)

  application_epg_dn = aci_application_epg.epg.id
  tdn                = each.value
}
