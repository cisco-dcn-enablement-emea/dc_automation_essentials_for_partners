locals {
  # Configure this according to your scenario
  site1_name                   = "MDR1"
  site2_name                   = "MLG1"
  vmm_site1_dn                 = "uni/vmmp-VMware/dom-vmm_vds"
  vmm_site2_dn                 = "uni/vmmp-VMware/dom-vmm_vds_mlg"
  l3out_name                   = "wan_l3out"
  stretched_base_template_name = "stretched_base"
  stretched_template_name      = "stretched"
  site1_template_name          = "mdr1_only"
  site2_template_name          = "mlg1_only"
  templates_redeploy           = false
}

# Create Tenant
resource "mso_tenant" "demo" {
  name         = "terraform_ndo_demo"
  display_name = "terraform_ndo_demo"

  site_associations {
    site_id = data.mso_site.site1.id
  }

  site_associations {
    site_id = data.mso_site.site2.id
  }

  user_associations {
    user_id = data.mso_user.current_user.id
  }
}

# Schema and Templates
resource "mso_schema" "ms_prod" {
  name = "terraform_ndo_demo_schema"

  template {
    name         = local.stretched_base_template_name
    display_name = local.stretched_base_template_name
    tenant_id    = mso_tenant.demo.id
  }
  template {
    name         = local.stretched_template_name
    display_name = local.stretched_template_name
    tenant_id    = mso_tenant.demo.id
  }
  template {
    name         = local.site1_template_name
    display_name = local.site1_template_name
    tenant_id    = mso_tenant.demo.id
  }
  template {
    name         = local.site2_template_name
    display_name = local.site2_template_name
    tenant_id    = mso_tenant.demo.id
  }
}

resource "mso_schema_site" "schema_site_1_tpl0" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site1.id
  template_name       = local.stretched_base_template_name
  undeploy_on_destroy = true
}

resource "mso_schema_site" "schema_site_1_tpl1" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site1.id
  template_name       = local.stretched_template_name
  undeploy_on_destroy = true
}

resource "mso_schema_site" "schema_site_1_tpl2" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site1.id
  template_name       = local.site1_template_name
  undeploy_on_destroy = true
}

resource "mso_schema_site" "schema_site_2_tpl0" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site2.id
  template_name       = local.stretched_base_template_name
  undeploy_on_destroy = true
}

resource "mso_schema_site" "schema_site_2_tpl1" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site2.id
  template_name       = local.stretched_template_name
  undeploy_on_destroy = true
}

resource "mso_schema_site" "schema_site_2_tpl2" {
  schema_id           = mso_schema.ms_prod.id
  site_id             = data.mso_site.site2.id
  template_name       = local.site2_template_name
  undeploy_on_destroy = true
}

# Configure template objects
module "schema_config" {
  source = "./modules/ndo_config"

  schema_id               = mso_schema.ms_prod.id
  template_stretched_base = local.stretched_base_template_name
  template_stretched      = local.stretched_template_name
  template_local_site1    = local.site1_template_name
  template_local_site2    = local.site2_template_name
  site1_id                = data.mso_site.site1.id
  site2_id                = data.mso_site.site2.id
  vmm_site1               = local.vmm_site1_dn
  vmm_site2               = local.vmm_site2_dn
  l3out_name              = local.l3out_name
}

# Deploy templates
resource "mso_schema_template_deploy_ndo" "template_stretched_base_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = local.stretched_base_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_stretched_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = local.stretched_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_local_s1_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = local.site1_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_local_s2_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = local.site2_template_name
  re_deploy     = local.templates_redeploy
}
