locals {
  tenant_dn = data.tfe_outputs.prod-tenant.values.tenant_dn
  vrf_dn    = data.tfe_outputs.prod-tenant.values.vrf_dn
}

resource "aci_application_profile" "payment_services" {
  tenant_dn   = local.tenant_dn
  name        = "payment_services"
  description = "Networks on payment_services block"
}

module "network-prod-fe-01" {
  source  = "app.terraform.io/spain-cn-lab/network/aci"
  version = "0.0.2"

  name      = "prod_net_front_01"
  tenant_dn = local.tenant_dn
  vrf_dn    = local.vrf_dn
  anp_dn    = aci_application_profile.payment_services.id

  type   = "L3"
  subnet = "192.168.1.1/24"
  public = true

  ports = [
    {
      pod_id          = "1"
      port_type       = "port"
      leaves_id       = "1101"
      port_id         = "eth1/31"
      vlan_id         = "151"
      switchport_type = "access"
    },
    {
      pod_id          = "1"
      port_type       = "port"
      leaves_id       = "1102"
      port_id         = "eth1/31"
      vlan_id         = "151"
      switchport_type = "access"
    }
  ]
}

module "network-prod-be-01" {
  source  = "app.terraform.io/spain-cn-lab/network/aci"
  version = "0.0.2"

  name      = "prod_net_back_01"
  tenant_dn = local.tenant_dn
  vrf_dn    = local.vrf_dn
  anp_dn    = aci_application_profile.payment_services.id

  type   = "L3"
  subnet = "192.168.2.1/24"
  public = true
}

module "network-prod-db-01" {
  source  = "app.terraform.io/spain-cn-lab/network/aci"
  version = "0.0.2"

  name      = "prod_net_db_01"
  tenant_dn = local.tenant_dn
  vrf_dn    = local.vrf_dn
  anp_dn    = aci_application_profile.payment_services.id

  type   = "L3"
  subnet = "192.168.3.1/24"
  public = true
}
