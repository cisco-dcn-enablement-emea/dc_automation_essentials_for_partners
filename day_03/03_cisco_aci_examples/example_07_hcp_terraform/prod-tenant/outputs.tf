output "tenant_dn" {
  value = aci_tenant.prod.id
}

output "vrf_dn" {
  value = aci_vrf.prod.id
}

output "l3out_dn" {
  value = module.core_l3out.id
}

output "wan_contract_dn" {
  value = aci_contract.wan.id
}
