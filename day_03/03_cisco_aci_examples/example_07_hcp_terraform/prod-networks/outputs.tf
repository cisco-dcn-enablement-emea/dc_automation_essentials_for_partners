output "networks_epg_dn" {
  value = {
    prod-fe-01 = module.network-prod-fe-01.epg_dn
    prod-be-01 = module.network-prod-be-01.epg_dn
    prod-db-01 = module.network-prod-db-01.epg_dn
  }
}
