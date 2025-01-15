terraform {
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = "0.5.6"  // Specify the version of the NXOS provider
    }
  }
}

provider "nxos" {
  url      = "https://${var.switch_host}"  // URL for connecting to the Nexus switch
  username = var.switch_username           // Username for authentication
  password = var.switch_password           // Password for authentication
}

# Enable LACP feature
resource "nxos_feature_lacp" "enable_lacp" {
  admin_state = "enabled"  // Ensure LACP is enabled on the switch
}

# Enable BGP feature
resource "nxos_feature_bgp" "enable_bgp" {
  admin_state = "enabled"  // Ensure BGP is enabled on the switch
}

# Enable Interface VLAN feature
resource "nxos_feature_interface_vlan" "enable_interface_vlan" {
  admin_state = "enabled"  // Ensure interface VLAN is enabled on the switch
}

# Create new VRF
resource "nxos_vrf" "vrf_config" {
  name = var.vrf_name  // Define the VRF name
}

# Configure a VLAN
resource "nxos_bridge_domain" "vlan_config" {
  fabric_encap = "vlan-${var.vlan_id}"  // Define the VLAN ID
  name         = var.vlan_name          // Define the VLAN name
}

# Configure an SVI (Switch Virtual Interface) for the VLAN
resource "nxos_svi_interface" "svi_config" {
  interface_id = replace(nxos_bridge_domain.vlan_config.fabric_encap, "-", "")  // Dynamically use vlanXXXX from the BD vlan id
  description  = "SVI configured via Terraform"  // Description for the SVI
}

# Link SVI to VRF
resource "nxos_svi_interface_vrf" "svi_vrf_binding" {
  interface_id = nxos_svi_interface.svi_config.interface_id  // Link to the SVI interface
  vrf_dn       = "sys/inst-${nxos_vrf.vrf_config.name}"      // Assign the VRF to the SVI
}

# Configure IPv4 for SVI
resource "nxos_ipv4_interface" "svi_ipv4_config" {
  vrf          = replace(nxos_svi_interface_vrf.svi_vrf_binding.vrf_dn, "sys/inst-", "")  // Link to the VRF
  interface_id = nxos_svi_interface_vrf.svi_vrf_binding.interface_id  // Link to the SVI interface
}

# Assign IP address to SVI
resource "nxos_ipv4_interface_address" "svi_ipv4_address_config" {
  vrf          = nxos_ipv4_interface.svi_ipv4_config.vrf  // Link to the VRF
  interface_id = nxos_ipv4_interface.svi_ipv4_config.interface_id  // Link to the SVI interface
  address      = var.svi_ip  // IP address for the SVI
  type         = "primary"
}

# Configure a Port-Channel for trunking
resource "nxos_port_channel_interface" "port_channel_config" {
  interface_id = "po${var.port_channel_id}"  // Define Port-Channel ID
  description  = "Port-Channel for VLAN trunking"
  mode         = "trunk"                     // Set mode to trunk
  depends_on   = [nxos_feature_lacp.enable_lacp]  // Ensure LACP is enabled first
}

# Add physical interfaces to the Port-Channel
resource "nxos_port_channel_interface_member" "port_channel_members" {
  for_each     = toset(var.pc_physical_interfaces)  // Loop through each physical interface
  interface_id = nxos_port_channel_interface.port_channel_config.interface_id  // Port-Channel ID
  interface_dn = "sys/intf/phys-[${each.value}]"    // Use dynamic interface DN from the list
  force        = true                               // Forcefully add interfaces
}

# Configure a physical interface for ISP uplink
resource "nxos_physical_interface" "isp_uplink_config" {
  interface_id = var.physical_interface  // Define the physical interface ID
  admin_state  = "up"                    // Bring the interface up
  description  = "TO_ISP"                // Description for the interface
  layer        = "Layer3"                // Set the interface to Layer 3
}

# Configure a subinterface with VLAN encapsulation
resource "nxos_subinterface" "subinterface_config" {
  interface_id = "${nxos_physical_interface.isp_uplink_config.interface_id}.${var.subinterface_id}"  // Link to the physical interface
  admin_state  = "up"                                             // Bring the subinterface up
  encap        = "vlan-${var.subinterface_id}"                    // VLAN encapsulation
  mtu          = 1500                                             // Set MTU size
}

# Assign a VRF to the subinterface
resource "nxos_subinterface_vrf" "subinterface_vrf_binding" {
  interface_id = nxos_subinterface.subinterface_config.interface_id  // Link to the subinterface
  vrf_dn       = "sys/inst-${nxos_vrf.vrf_config.name}"              // Assign the VRF
}

# Configure IPv4 for the subinterface
resource "nxos_ipv4_interface" "subinterface_ipv4_config" {
  vrf          = replace(nxos_subinterface_vrf.subinterface_vrf_binding.vrf_dn, "sys/inst-", "")  // Link to the VRF
  interface_id = nxos_subinterface_vrf.subinterface_vrf_binding.interface_id  // Link to the subinterface
}

# Assign IP address to the subinterface
resource "nxos_ipv4_interface_address" "subinterface_ipv4_address_config" {
  vrf          = nxos_ipv4_interface.subinterface_ipv4_config.vrf  // Link to the VRF
  interface_id = nxos_ipv4_interface.subinterface_ipv4_config.interface_id  // Link to the subinterface
  address      = var.subinterface_ip  // IP address for the subinterface
  type         = "primary"
}

# Configure BGP instance
resource "nxos_bgp_instance" "bgp_instance_config" {
  admin_state             = "enabled"          // Enable BGP
  asn                     = var.bgp_as_number  // Local AS number
  enhanced_error_handling = true               // Enable enhanced error handling
}

# Configure BGP VRF
resource "nxos_bgp_vrf" "bgp_vrf_config" {
  asn       = nxos_bgp_instance.bgp_instance_config.asn  // Use ASN from BGP instance
  name      = nxos_vrf.vrf_config.name  // Use VRF name
  router_id = "1.1.1.1"  // Router ID for the BGP VRF -- Consider making this a variable
}

# Add address family to BGP VRF
resource "nxos_bgp_address_family" "bgp_afi_config" {
  asn            = nxos_bgp_vrf.bgp_vrf_config.asn
  vrf            = nxos_bgp_vrf.bgp_vrf_config.name
  address_family = "ipv4-ucast"
}

# Configure BGP peer
resource "nxos_bgp_peer" "bgp_peer_config" {
  asn              = nxos_bgp_address_family.bgp_afi_config.asn  // Use ASN from BGP instance
  vrf              = nxos_bgp_address_family.bgp_afi_config.vrf  // VRF name
  address          = var.bgp_neighbor_ip  // Neighbor IP address
  remote_asn       = var.bgp_remote_as    // Remote AS number
  source_interface = nxos_subinterface.subinterface_config.interface_id  // Source interface for the peer
}

# Advertise network prefixes via BGP
resource "nxos_bgp_advertised_prefix" "bgp_advertised_prefix_config" {
  asn            = nxos_bgp_peer.bgp_peer_config.asn  // Use ASN from BGP instance
  vrf            = nxos_bgp_peer.bgp_peer_config.vrf  // VRF name
  address_family = "ipv4-ucast"                       // Address family
  prefix         = "${cidrsubnet(var.subinterface_ip, 0, 0)}"  // Prefix to advertise
}

resource "nxos_rest" "hsrpEntity" {
  dn         = "sys/bgpEntity/bgpInst"
  class_name = "hsrpEntity"
  content = {
    adminSt = "enabled"
  }
}