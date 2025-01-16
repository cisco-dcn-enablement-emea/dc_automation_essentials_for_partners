terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

# Contract Filter
resource "aci_filter" "flt" {
  tenant_dn = var.tenant_dn
  name      = var.name
}

resource "aci_filter_entry" "flte" {
  for_each = var.filter_entries

  filter_dn   = aci_filter.flt.id
  name        = each.value.name
  ether_t     = each.value.ether_t
  prot        = each.value.prot
  d_from_port = each.value.d_from_port
  d_to_port   = each.value.d_to_port
}
