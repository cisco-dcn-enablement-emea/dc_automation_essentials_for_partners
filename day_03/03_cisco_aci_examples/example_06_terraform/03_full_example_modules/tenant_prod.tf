### Tenant Definition
resource "aci_tenant" "prod" {
  name = "tf_prod"
}

### Networking

# VRFs

module "prod_vrf" {
  source = "./modules/aci_vrf"

  name      = "prod_vrf"
  tenant_dn = aci_tenant.prod.id
}

# Bridge Domains

module "prod_192_168_1_0" {
  source = "./modules/aci_bd"

  name      = "192.168.1.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.1.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.prod.id
  vrf_dn    = module.prod_vrf.id
}

module "prod_192_168_2_0" {
  source = "./modules/aci_bd"

  name      = "192.168.2.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.2.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.prod.id
  vrf_dn    = module.prod_vrf.id
}

module "prod_192_168_3_0" {
  source = "./modules/aci_bd"

  name      = "192.168.3.0_24_bd"
  type      = "L3"
  ip_addr   = "192.168.3.1/24"
  scope     = ["private"]
  tenant_dn = aci_tenant.prod.id
  vrf_dn    = module.prod_vrf.id
}

### App Profiles

# Apps
resource "aci_application_profile" "hrms" {
  name      = "hrms_app"
  tenant_dn = aci_tenant.prod.id
}

# EPGs
module "hrms_frontend_epg" {
  source = "./modules/aci_epg"

  name                  = "hrms_frontend_epg"
  name_alias            = "hrms_ngnix"
  pref_gr_memb          = "exclude"
  app_profile_dn        = aci_application_profile.hrms.id
  bridge_domain_dn      = module.prod_192_168_1_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
  cons_contracts_dn     = [module.hrms_fe_be_con.id]
  prov_contracts_dn     = [module.hrms_inet_fe_con.id]
}

module "hrms_backend_epg" {
  source = "./modules/aci_epg"

  name                  = "hrms_backend_epg"
  name_alias            = "hrms_nodejs"
  pref_gr_memb          = "exclude"
  app_profile_dn        = aci_application_profile.hrms.id
  bridge_domain_dn      = module.prod_192_168_2_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
  cons_contracts_dn     = [module.hrms_be_db_con.id]
  prov_contracts_dn     = [module.hrms_fe_be_con.id]
}

module "hrms_database_epg" {
  source = "./modules/aci_epg"

  name                  = "hrms_database_epg"
  name_alias            = "hrms_mongodb"
  pref_gr_memb          = "exclude"
  app_profile_dn        = aci_application_profile.hrms.id
  bridge_domain_dn      = module.prod_192_168_3_0.id
  associated_domains_dn = [data.aci_vmm_domain.mdr.id]
  cons_contracts_dn     = []
  prov_contracts_dn     = [module.hrms_be_db_con.id]
}

### Security

# Contracts
module "hrms_fe_be_con" {
  source = "./modules/aci_contract"

  name  = "hrms_fe_be_con"
  tenant_dn = aci_tenant.prod.id
  scope = "context"
  subjects = {
    "web" = {
      name = "web_traffic"
      filters_dn = [
        module.http_flt.id,
        module.https_flt.id
      ]
    }
  }
}

module "hrms_be_db_con" {
  source = "./modules/aci_contract"

  name  = "hrms_be_db_con"
  tenant_dn = aci_tenant.prod.id
  scope = "context"
  subjects = {
    "db" = {
      name = "db_traffic"
      filters_dn = [
        module.mongo_flt.id
      ]
    }
  }
}

module "hrms_inet_fe_con" {
  source = "./modules/aci_contract"

  name  = "hrms_inet_fe_con"
  tenant_dn = aci_tenant.prod.id
  scope = "context"
  subjects = {
    "web" = {
      name = "secure_web_traffic"
      filters_dn = [
        module.https_flt.id
      ]
    }
  }
}

# Filters
module "http_flt" {
  source = "./modules/aci_filter"

  name      = "http"
  tenant_dn = aci_tenant.prod.id
  filter_entries = {
    "http" = {
      name        = "http"
      ether_t     = "ip"
      prot        = "tcp"
      d_from_port = "http"
      d_to_port   = "http"
    }
  }
}

module "https_flt" {
  source = "./modules/aci_filter"

  name      = "https"
  tenant_dn = aci_tenant.prod.id
  filter_entries = {
    "https" = {
      name        = "https"
      ether_t     = "ip"
      prot        = "tcp"
      d_from_port = "https"
      d_to_port   = "https"
    }
  }
}

module "mongo_flt" {
  source = "./modules/aci_filter"

  name      = "mongo"
  tenant_dn = aci_tenant.prod.id
  filter_entries = {
    "mongo" = {
      name        = "mongo"
      ether_t     = "ip"
      prot        = "tcp"
      d_from_port = "27017"
      d_to_port   = "27017"
    }
  }
}


