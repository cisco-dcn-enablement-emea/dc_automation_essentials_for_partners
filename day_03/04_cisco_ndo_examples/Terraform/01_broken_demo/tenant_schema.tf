locals {
  stretched_base_template_name = "stretched_base"
  stretched_template_name      = "stretched"
  site1_template_name          = "${lower(var.site1)}_only"
  site2_template_name          = "${lower(var.site2)}_only"
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

# Deploy templates
resource "mso_schema_template_deploy_ndo" "template_stretched_base_deployer" {
  schema_id     = mso_schema.ms_prod.id
  template_name = local.stretched_base_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_stretched_deployer" {
  schema_id     = mso_schema.ms_prod.id
  template_name = local.stretched_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_local_s1_deployer" {
  schema_id     = mso_schema.ms_prod.id
  template_name = local.site1_template_name
  re_deploy     = local.templates_redeploy
}

resource "mso_schema_template_deploy_ndo" "template_local_s2_deployer" {
  schema_id     = mso_schema.ms_prod.id
  template_name = local.site2_template_name
  re_deploy     = local.templates_redeploy
}





