terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "2.0.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  external_epg_subnets = flatten([
    for l3epg_key, l3epg in var.external_epgs : [
      for subnet_key, subnet in l3epg.subnets : {
        external_epg_key  = l3epg_key
        external_epg_name = l3epg.name
        subnet_key        = subnet_key
        subnet_ip         = subnet.ip
        subnet_scope      = subnet.scope
      }
    ]
  ])
}

resource "aci_l3_outside" "l3out" {
  tenant_dn                    = var.tenant_id
  name                         = var.name
  relation_l3ext_rs_ectx       = var.vrf_id
  relation_l3ext_rs_l3_dom_att = var.l3_ext_domain_id
}

resource "aci_l3out_bgp_external_policy" "bgp" {
  l3_outside_dn = aci_l3_outside.l3out.id
}

resource "aci_logical_node_profile" "l3np" {
  l3_outside_dn = aci_l3_outside.l3out.id
  name          = "${var.name}_np"
}

resource "aci_logical_node_to_fabric_node" "l3np_node" {
  for_each = var.nodes

  logical_node_profile_dn = aci_logical_node_profile.l3np.id
  tdn                     = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
  rtr_id                  = each.value.rtr_id
  rtr_id_loop_back        = each.value.rtr_id_loopback
}

resource "aci_logical_interface_profile" "l3ip" {
  logical_node_profile_dn = aci_logical_node_profile.l3np.id
  name                    = "${var.name}_ip"
}

resource "aci_l3out_path_attachment" "l3ip_path" {
  for_each = var.paths

  logical_interface_profile_dn = aci_logical_interface_profile.l3ip.id
  target_dn                    = "topology/pod-${each.value.pod_id}/paths-${each.value.node_id}/pathep-[${each.value.port_id}]"
  if_inst_t                    = "l3-port"
  addr                         = each.value.ip_addr
  mode                         = each.value.mode
  mtu                          = each.value.mtu
}

resource "aci_bgp_peer_connectivity_profile" "bgp_peer" {
  for_each = var.bgp_peers

  parent_dn           = aci_logical_node_profile.l3np.id
  addr                = each.value.peer_addr
  addr_t_ctrl         = ["af-ucast"]
  allowed_self_as_cnt = "3"
  ctrl                = ["send-com", "send-ext-com"]
  ttl                 = "1"
  weight              = "0"
  as_number           = each.value.peer_asn
  local_asn           = each.value.local_asn
  local_asn_propagate = "replace-as"
}

# External Network Instance Profiles
resource "aci_external_network_instance_profile" "l3instp" {
  for_each = var.external_epgs

  l3_outside_dn = aci_l3_outside.l3out.id
  name          = each.value.name
  pref_gr_memb  = each.value.prefGrp
  # relation_fv_rs_prov     = each.value.provided_contracts
  # relation_fv_rs_cons     = each.value.consumed_contracts
}

resource "aci_l3_ext_subnet" "l3instp_subnet" {
  for_each = {
    for subnet in local.external_epg_subnets : "${subnet.external_epg_key}.${subnet.subnet_key}" => subnet
  }

  external_network_instance_profile_dn = aci_external_network_instance_profile.l3instp[each.value.external_epg_key].id
  ip                                   = each.value.subnet_ip
  scope                                = each.value.subnet_scope
}
