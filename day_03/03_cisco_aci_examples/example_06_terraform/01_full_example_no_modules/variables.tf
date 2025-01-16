variable "tenants" {
  type = map(object({
    name = string
  }))
}

variable "vrfs" {
  type = map(object({
    name    = string
    pref_gr = string

    vzany = object({
      prov_contracts_key = list(string)
      cons_contracts_key = list(string)
    })

    parent_tn_key = string
  }))
}

variable "bridge_domains" {
  type = map(object({
    name                 = string
    type                 = string
    ip_addr              = string
    scope                = list(string)
    associated_l3outs_dn = list(string)

    parent_tn_key    = string
    relation_vrf_key = string
  }))
}

variable "app_profiles" {
  type = map(object({
    name          = string
    parent_tn_key = string
  }))
}

variable "app_epgs" {
  type = map(object({
    name         = string
    name_alias   = string
    pref_gr_memb = string

    parent_app_key  = string
    relation_bd_key = string

    domains_dn = list(string)

    cons_contracts_key = list(string)
    prov_contracts_key = list(string)
  }))
}

variable "contracts" {
  type = map(object({
    name  = string
    scope = string

    subjects = map(object({
      name        = string
      filters_key = list(string)
    }))

    parent_tn_key = string
  }))
}

variable "filters" {
  type = map(object({
    name = string
    filter_entries = map(object({
      name        = string
      ether_t     = string
      prot        = string
      d_from_port = string
      d_to_port   = string
    }))

    parent_tn_key = string
  }))
}



