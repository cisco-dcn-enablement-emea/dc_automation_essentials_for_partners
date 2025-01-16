### VMM
data "aci_vmm_domain" "mdr" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = "vmm_vds"
}