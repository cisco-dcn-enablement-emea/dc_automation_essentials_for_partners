terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

# Contract Definitions
resource "aci_contract" "brc" {
  tenant_dn = var.tenant_dn
  name      = var.name
  scope     = var.scope
}

# Subject Definitions
resource "aci_contract_subject" "subj" {
  for_each = var.subjects

  contract_dn                  = aci_contract.brc.id
  name                         = each.value.name
  relation_vz_rs_subj_filt_att = each.value.filters_dn
}
