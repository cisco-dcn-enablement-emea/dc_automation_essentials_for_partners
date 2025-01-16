### BD
# Template level
resource "mso_schema_template_bd" "bd1" {
  schema_id              = mso_schema.ms_prod.id
  template_name          = local.stretched_template_name
  name                   = "10_10_10_0_24_bd"
  display_name           = "10_10_10_0_24_bd"
  vrf_name               = mso_schema_template_vrf.prod.name
  layer2_stretch         = true
  unicast_routing        = true
  intersite_bum_traffic  = true
  layer2_unknown_unicast = "proxy"
}

resource "mso_schema_template_bd_subnet" "bd1net" {
  schema_id          = mso_schema.ms_prod.id
  template_name      = local.stretched_template_name
  bd_name            = mso_schema_template_bd.bd1.name
  ip                 = "10.10.10.1/24"
  scope              = "private"
  no_default_gateway = false
  shared             = false
}

resource "mso_schema_template_bd" "bd2" {
  schema_id              = mso_schema.ms_prod.id
  template_name          = local.stretched_template_name
  name                   = "10_10_20_0_24_bd"
  display_name           = "10_10_20_0_24_bd"
  vrf_name               = mso_schema_template_vrf.prod.name
  layer2_stretch         = true
  unicast_routing        = true
  intersite_bum_traffic  = true
  layer2_unknown_unicast = "proxy"
}

resource "mso_schema_template_bd_subnet" "bd2net" {
  schema_id          = mso_schema.ms_prod.id
  template_name      = local.stretched_template_name
  bd_name            = mso_schema_template_bd.bd2.name
  ip                 = "10.10.20.1/24"
  scope              = "private"
  no_default_gateway = false
  shared             = false
}

# Site level

### APP and EPGs
# Template level
resource "mso_schema_template_anp" "demo_app" {
  schema_id    = mso_schema.ms_prod.id
  template     = local.stretched_template_name
  name         = "demo_app"
  display_name = "demo_app"
}

resource "mso_schema_template_anp_epg" "demo_web_epg" {
  schema_id       = mso_schema.ms_prod.id
  template_name   = local.stretched_template_name
  anp_name        = mso_schema_template_anp.demo_app.name
  name            = "web_epg"
  display_name    = "web_epg"
  bd_name         = mso_schema_template_bd.bd1.name
  vrf_name        = mso_schema_template_vrf.prod.name
  preferred_group = true
}

resource "mso_schema_template_anp_epg" "demo_app_epg" {
  schema_id       = mso_schema.ms_prod.id
  template_name   = local.stretched_template_name
  anp_name        = mso_schema_template_anp.demo_app.name
  name            = "app_epg"
  display_name    = "app_epg"
  bd_name         = mso_schema_template_bd.bd2.name
  vrf_name        = mso_schema_template_vrf.prod.name
  preferred_group = true
}

# Site level
resource "mso_schema_site_anp_epg_domain" "demo_web_epg_s1_vmm" {
  schema_id            = mso_schema.ms_prod.id
  template_name        = local.stretched_template_name
  site_id              = data.mso_site.site1.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_web_epg.name
  domain_dn            = var.vmm_site1
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  binding_type         = "none"
  netflow              = "disabled"
  allow_promiscuous    = "reject"
  mac_changes          = "reject"
  forged_transmits     = "reject"
}

resource "mso_schema_site_anp_epg_domain" "demo_web_epg_s2_vmm" {
  schema_id            = mso_schema.ms_prod.id
  template_name        = local.stretched_template_name
  site_id              = data.mso_site.site2.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_web_epg.name
  domain_dn            = var.vmm_site2
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  binding_type         = "none"
  netflow              = "disabled"
  allow_promiscuous    = "reject"
  mac_changes          = "reject"
  forged_transmits     = "reject"
}

resource "mso_schema_site_anp_epg_domain" "demo_app_epg_s1_vmm" {
  schema_id            = mso_schema.ms_prod.id
  template_name        = local.stretched_template_name
  site_id              = data.mso_site.site1.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_app_epg.name
  domain_dn            = var.vmm_site1
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  binding_type         = "none"
  netflow              = "disabled"
  allow_promiscuous    = "reject"
  mac_changes          = "reject"
  forged_transmits     = "reject"
}

resource "mso_schema_site_anp_epg_domain" "demo_app_epg_s2_vmm" {
  schema_id            = mso_schema.ms_prod.id
  template_name        = local.stretched_template_name
  site_id              = data.mso_site.site2.id
  anp_name             = mso_schema_template_anp.demo_app.name
  epg_name             = mso_schema_template_anp_epg.demo_app_epg.name
  domain_dn            = var.vmm_site2
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  binding_type         = "none"
  netflow              = "disabled"
  allow_promiscuous    = "reject"
  mac_changes          = "reject"
  forged_transmits     = "reject"
}

### L3OUT

# Template level
resource "mso_schema_template_l3out" "wan" {
  schema_id     = mso_schema.ms_prod.id
  template_name = local.stretched_template_name
  l3out_name    = var.l3out_name
  display_name  = var.l3out_name
  vrf_name      = mso_schema_template_vrf.prod.name
}

resource "mso_schema_template_external_epg" "default_l3epg" {
  schema_id         = mso_schema.ms_prod.id
  template_name     = local.stretched_template_name
  external_epg_name = "default_l3epg"
  external_epg_type = "on-premise"
  display_name      = "default_l3epg"
  vrf_name          = mso_schema_template_vrf.prod.name
  l3out_name        = mso_schema_template_l3out.wan.l3out_name
}

# resource "mso_schema_template_external_epg_subnet" "default_l3epg" {
#   schema_id         = mso_schema.ms_prod.id
#   template_name     = local.stretched_template_name
#   external_epg_name = mso_schema_template_external_epg.default_l3epg.external_epg_name
#   ip                = "0.0.0.0/0"
#   name              = "default"
#   scope             = ["import-security"]
# }
