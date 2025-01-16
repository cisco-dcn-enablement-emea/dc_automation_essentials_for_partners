### BD
# Template level
resource "mso_schema_template_bd" "bd3" {
  schema_id              = var.schema_id
  template_name          = var.template_local_site1
  name                   = "10_10_30_0_24_bd"
  display_name           = "10_10_30_0_24_bd"
  vrf_name               = mso_schema_template_vrf.prod.name
  vrf_template_name      = mso_schema_template_vrf.prod.template
  layer2_stretch         = false
  unicast_routing        = true
  layer2_unknown_unicast = "proxy"
}

resource "mso_schema_site_bd_subnet" "bd3net" {
  schema_id          = var.schema_id
  template_name      = var.template_local_site1
  site_id            = var.site1_id
  bd_name            = mso_schema_template_bd.bd3.name
  ip                 = "10.10.30.1/24"
  scope              = "private"
  no_default_gateway = false
  shared             = false
}

### APP and EPGs
# Template level
resource "mso_schema_template_anp" "demo_app_s1" {
  schema_id    = var.schema_id
  template     = var.template_local_site1
  name         = "demo_app"
  display_name = "demo_app"
}

resource "mso_schema_template_anp_epg" "demo_db_epg" {
  schema_id         = var.schema_id
  template_name     = var.template_local_site1
  anp_name          = mso_schema_template_anp.demo_app_s1.name
  name              = "database_epg"
  display_name      = "database_epg"
  bd_name           = mso_schema_template_bd.bd3.name
  vrf_name          = mso_schema_template_vrf.prod.name
  vrf_template_name = mso_schema_template_vrf.prod.template
  preferred_group   = true
}

resource "mso_schema_site_anp_epg_domain" "demo_db_epg_s1_vmm" {
  schema_id            = var.schema_id
  template_name        = var.template_local_site1
  site_id              = var.site1_id
  anp_name             = mso_schema_template_anp.demo_app_s1.name
  epg_name             = mso_schema_template_anp_epg.demo_db_epg.name
  domain_dn            = var.vmm_site1
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  binding_type         = "none"
  netflow              = "disabled"
  allow_promiscuous    = "reject"
  mac_changes          = "reject"
  forged_transmits     = "reject"
}

