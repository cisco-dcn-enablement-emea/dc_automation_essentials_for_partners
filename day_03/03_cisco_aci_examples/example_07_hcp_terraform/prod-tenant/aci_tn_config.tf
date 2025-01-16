# Tenant
resource "aci_tenant" "prod" {
  name = "iac_demo_tn"
}

# VRF
resource "aci_vrf" "prod" {
  tenant_dn = aci_tenant.prod.id
  name      = "prod_vrf"
}

# L3Out
data "aci_l3_domain_profile" "core" {
  name = "core_l3dom"
}

module "core_l3out" {
  source = "github.com/adealdag/terraform-aci-l3out?ref=v0.3.0"

  name      = "core_l3out"
  tenant_dn = aci_tenant.prod.id
  vrf_dn    = aci_vrf.prod.id
  l3dom_dn  = data.aci_l3_domain_profile.core.id

  bgp = {
    enabled = true
  }

  nodes = {
    "1101" = {
      pod_id             = "1"
      node_id            = "1101"
      router_id          = "1.1.1.101"
      router_id_loopback = "no"
    },
    "1102" = {
      pod_id             = "1"
      node_id            = "1102"
      router_id          = "1.1.1.102"
      router_id_loopback = "no"
    }
  }

  interfaces = {
    "1101_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1101"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.32.10/30"
      vlan_encap       = "vlan-32"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "core01" = {
          peer_ip_addr     = "172.16.32.9"
          peer_asn         = "65032"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    },
    "1102_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1102"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.32.14/30"
      vlan_encap       = "vlan-32"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "core01" = {
          peer_ip_addr     = "172.16.32.13"
          peer_asn         = "65032"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    }
  }

  external_l3epg = {
    "default" = {
      name         = "default"
      pref_gr_memb = "exclude"
      subnets = {
        "default" = {
          prefix = "0.0.0.0/0"
          scope  = ["import-security"]
        }
      }
      prov_contracts = [aci_contract.wan.id]
    }
  }
}

# Contract
resource "aci_contract" "wan" {
  tenant_dn = aci_tenant.prod.id
  name      = "internal_to_wan"
  scope     = "context"
}

resource "aci_contract_subject" "permit_any" {
  contract_dn                  = aci_contract.wan.id
  name                         = "permit_any"
  relation_vz_rs_subj_filt_att = [aci_filter.any.id]
}

resource "aci_filter" "any" {
  tenant_dn = aci_tenant.prod.id
  name      = "any"
}

resource "aci_filter_entry" "any" {
  filter_dn = aci_filter.any.id
  name      = "any"
  ether_t   = "unspecified"
}

