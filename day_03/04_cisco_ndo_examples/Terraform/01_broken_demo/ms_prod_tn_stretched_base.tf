### VRF
# Template level
resource "mso_schema_template_vrf" "prod" {
  schema_id              = mso_schema.ms_prod.id
  template               = local.stretched_template_name
  name                   = "prod_vrf"
  display_name           = "prod_vrf"
  ip_data_plane_learning = "enabled"
  preferred_group        = true
}
