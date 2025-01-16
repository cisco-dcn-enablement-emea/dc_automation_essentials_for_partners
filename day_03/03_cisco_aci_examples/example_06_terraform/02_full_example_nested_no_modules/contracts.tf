### Locals
locals {
  contracts = flatten([
    for tn_key, tn_value in var.tenants : [
      for brc_key, brc_value in tn_value.contracts : {
        parent_tn_key = tn_key
        contract_key  = brc_key
        contract      = brc_value
      }
    ]
  ])

  subjects = flatten([
    for tn_key, tn_value in var.tenants : [
      for brc_key, brc_value in tn_value.contracts : [
        for subj_key, subj_value in brc_value.subjects : {
          parent_brc_key = brc_key
          subj_key       = subj_key
          subj           = subj_value
        }
      ]
    ]
  ])

  filters = flatten([
    for tn_key, tn_value in var.tenants : [
      for flt_key, flt_value in tn_value.filters : {
        parent_tn_key = tn_key
        flt_key       = flt_key
        flt           = flt_value
      }
    ]
  ])

  flt_entries = flatten([
    for tn_key, tn_value in var.tenants : [
      for flt_key, flt_value in tn_value.filters : [
        for e_key, e_value in flt_value.filter_entries : {
          parent_flt_key = flt_key
          entry_key      = e_key
          entry          = e_value
        }
      ]
    ]
  ])
}

### Contracts

# Contract Definitions
resource "aci_contract" "brc" {
  for_each = {
    for item in local.contracts : item.contract_key => item
  }

  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
  name      = each.value.contract.name
  scope     = each.value.contract.scope
}

# Subject Definitions
resource "aci_contract_subject" "subj" {
  for_each = {
    for item in local.subjects : "${item.parent_brc_key}_${item.subj_key}" => item
  }

  contract_dn                  = aci_contract.brc[each.value.parent_brc_key].id
  name                         = each.value.subj.name
  relation_vz_rs_subj_filt_att = [for k in each.value.subj.filters_key : aci_filter.flt[k].id]
}

# Contract Filters

resource "aci_filter" "flt" {
  for_each = {
   for item in local.filters : item.flt_key => item
  }

  tenant_dn = aci_tenant.tn[each.value.parent_tn_key].id
  name      = each.value.flt.name
}

resource "aci_filter_entry" "flte" {
  for_each = {
    for item in local.flt_entries : "${item.parent_flt_key}_${item.entry_key}" => item
  }

  filter_dn   = aci_filter.flt[each.value.parent_flt_key].id
  name        = each.value.entry.name
  ether_t     = each.value.entry.ether_t
  prot        = each.value.entry.prot
  d_from_port = each.value.entry.d_from_port
  d_to_port   = each.value.entry.d_to_port
}
