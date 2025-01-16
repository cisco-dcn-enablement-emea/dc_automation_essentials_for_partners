### Tenant Definition
resource "aci_tenant" "dev" {
  name = "tf_dev"
}

### Networking

# VRFs

module "dev_vrf" {
  source = "./modules/aci_vrf"

  name      = "dev_vrf"
  tenant_dn = aci_tenant.dev.id
  pref_gr   = "enabled"
}

# Bridge Domains

module "prod_192_168_101_0" {
  source = "./modules/aci_bd"

  name      = "192.168.101.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.101.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.dev.id
  vrf_dn    = module.dev_vrf.id
}

module "prod_192_168_102_0" {
  source = "./modules/aci_bd"

  name      = "192.168.102.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.102.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.dev.id
  vrf_dn    = module.dev_vrf.id
}

module "prod_192_168_103_0" {
  source = "./modules/aci_bd"

  name      = "192.168.103.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.103.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.dev.id
  vrf_dn    = module.dev_vrf.id
}

### App Profiles

# Apps
resource "aci_application_profile" "demo" {
  name      = "demo_app"
  tenant_dn = aci_tenant.dev.id
}

# EPGs
module "demo_web_epg" {
  source = "./modules/aci_epg"

  name                  = "demo_web_epg"
  pref_gr_memb          = "include"
  app_profile_dn        = aci_application_profile.demo.id
  bridge_domain_dn      = module.prod_192_168_101_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
}

module "demo_app_epg" {
  source = "./modules/aci_epg"

  name                  = "demo_app_epg"
  pref_gr_memb          = "include"
  app_profile_dn        = aci_application_profile.demo.id
  bridge_domain_dn      = module.prod_192_168_102_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
}

module "demo_db_epg" {
  source = "./modules/aci_epg"

  name                  = "demo_db_epg"
  pref_gr_memb          = "include"
  app_profile_dn        = aci_application_profile.demo.id
  bridge_domain_dn      = module.prod_192_168_103_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
}

### Security

# Contracts

# Filters

