terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.15.0"
    }
  }
}

# provider "aci" {
#   # Credentials will be provided as environment variables
# }

data "aci_tenant" "project_tenant" {
  name = var.tenant_name
}

data "aci_vrf" "project_vrf" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = var.vrf_name
}

data "aci_l3_outside" "public_l3out" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = "public_l3out"
}

data "aci_vmm_domain" "vmmdom" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = "vmm_vds"
}

resource "aci_bridge_domain" "project_bd" {
  tenant_dn         = data.aci_tenant.project_tenant.id
  name              = var.project_name
  unicast_route     = "yes"
  unk_mac_ucast_act = "proxy"
  unk_mcast_act     = "flood"
  arp_flood         = "yes"

  relation_fv_rs_ctx = data.aci_vrf.project_vrf.id
}

resource "aci_subnet" "project_subnet" {
  parent_dn = aci_bridge_domain.project_bd.id
  ip        = var.project_subnet
  scope     = [var.project_subnet_scope]
  preferred = "yes"

  relation_fv_rs_bd_subnet_to_out = [var.project_subnet_scope == "public" ? data.aci_l3_outside.public_l3out.id : null]
}

resource "aci_application_profile" "project_ap" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = var.project_name
}

resource "aci_application_epg" "project_frontend" {
  application_profile_dn = aci_application_profile.project_ap.id
  name                   = "frontend"

  relation_fv_rs_bd   = aci_bridge_domain.project_bd.id
  relation_fv_rs_cons = [aci_contract.project_inner_contract.id]
  relation_fv_rs_prov = [aci_contract.project_inner_contract.id, aci_contract.project_outer_contract.id]
}

resource "aci_epg_to_domain" "project_frontend_vmm" {
  application_epg_dn = aci_application_epg.project_frontend.id
  tdn                = data.aci_vmm_domain.vmmdom.id
  res_imedcy         = "immediate"
  instr_imedcy       = "immediate"
}

resource "aci_application_epg" "project_backend" {
  application_profile_dn = aci_application_profile.project_ap.id
  name                   = "backend"

  relation_fv_rs_bd   = aci_bridge_domain.project_bd.id
  relation_fv_rs_cons = [aci_contract.project_inner_contract.id]
  relation_fv_rs_prov = [aci_contract.project_inner_contract.id]
}

resource "aci_epg_to_domain" "project_backend_vmm" {
  application_epg_dn = aci_application_epg.project_backend.id
  tdn                = data.aci_vmm_domain.vmmdom.id
  res_imedcy         = "immediate"
  instr_imedcy       = "immediate"
}

resource "aci_application_epg" "project_database" {
  application_profile_dn = aci_application_profile.project_ap.id
  name                   = "database"

  relation_fv_rs_bd   = aci_bridge_domain.project_bd.id
  relation_fv_rs_cons = [aci_contract.project_inner_contract.id]
  relation_fv_rs_prov = [aci_contract.project_inner_contract.id]
}

resource "aci_epg_to_domain" "project_database_vmm" {
  application_epg_dn = aci_application_epg.project_database.id
  tdn                = data.aci_vmm_domain.vmmdom.id
  res_imedcy         = "immediate"
  instr_imedcy       = "immediate"
}

resource "aci_contract" "project_inner_contract" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = "${var.project_name}_inner_contract"
  scope     = "application-profile"

  filter {
    filter_name = "ip_any"
    filter_entry {
      filter_entry_name = "ip"
      ether_t           = "ip"
      prot              = "unspecified"
    }
  }
}

resource "aci_contract" "project_outer_contract" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = "${var.project_name}_outer_contract"
  scope     = "tenant"
}

resource "aci_contract_subject" "project_outer_contract_subject" {
  contract_dn           = aci_contract.project_outer_contract.id
  name                  = "subject"
  apply_both_directions = "yes"
  rev_flt_ports         = "yes"
}

resource "aci_contract_subject_filter" "project_outer_contract_subject_filter" {
  contract_subject_dn = aci_contract_subject.project_outer_contract_subject.id
  filter_dn           = aci_filter.project_outer_contract_filter.id
  action              = "permit"
  directives          = ["log"]
}

resource "aci_filter" "project_outer_contract_filter" {
  tenant_dn = data.aci_tenant.project_tenant.id
  name      = "${var.project_name}_outer_contract_filter"
}

resource "aci_filter_entry" "project_outer_contract_filter_entry" {
  for_each = toset(var.project_open_ports)

  filter_dn   = aci_filter.project_outer_contract_filter.id
  name        = "entry"
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = each.value
  d_to_port   = each.value
}



