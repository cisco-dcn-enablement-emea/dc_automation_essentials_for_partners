### VRF
# Template level
resource "mso_schema_template_vrf" "prod" {
  schema_id              = var.schema_id
  template               = var.template_stretched
  name                   = "prod_vrf"
  display_name           = "prod_vrf"
  ip_data_plane_learning = "enabled"
  preferred_group        = true
}
