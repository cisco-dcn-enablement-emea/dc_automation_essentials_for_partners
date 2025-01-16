### Tenant Definition
resource "aci_tenant" "tn" {
  for_each = var.tenants
  
  name     = each.value.name
}