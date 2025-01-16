variable "tenants" {
  type = map(object({
    name = string

    vrfs = map(object({
      name    = string
      pref_gr = string

      vzany = object({
        prov_contracts_key = list(string)
        cons_contracts_key = list(string)
      })
    }))

    bridge_domains = map(object({
      name                 = string
      type                 = string
      ip_addr              = string
      scope                = list(string)
      associated_l3outs_dn = list(string)

      relation_vrf_key = string
    }))

    app_profiles = map(object({
      name = string

      epgs = map(object({
        name         = string
        name_alias   = string
        pref_gr_memb = string

        relation_bd_key = string

        domains_dn = list(string)

        cons_contracts_key = list(string)
        prov_contracts_key = list(string)
      }))
    }))

    contracts = map(object({
      name  = string
      scope = string

      subjects = map(object({
        name        = string
        filters_key = list(string)
      }))
    }))

    filters = map(object({
      name = string
      filter_entries = map(object({
        name        = string
        ether_t     = string
        prot        = string
        d_from_port = string
        d_to_port   = string
      }))
    }))
  }))
}


