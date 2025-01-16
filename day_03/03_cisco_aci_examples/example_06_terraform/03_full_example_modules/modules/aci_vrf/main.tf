terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

# VRF
resource "aci_vrf" "vrf" {
  tenant_dn = var.tenant_dn
  name      = var.name
}

# VRF - vzAny
resource "aci_any" "vzany" {
  vrf_dn       = aci_vrf.vrf.id
  pref_gr_memb = var.pref_gr

  relation_vz_rs_any_to_cons = var.vzany.cons_contracts_dn
  relation_vz_rs_any_to_prov = var.vzany.prov_contracts_dn
}
