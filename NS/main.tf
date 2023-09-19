terraform {
    backend "azurerm" {}
}


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}
module "contos" {
    source = "./modules/contos"
    managementgroup = var.managementgroup
    
}
module "decom" {
    source = "./modules/contos/decom"
    childgroupA0 =var.childgroupA0
    managementgroup-parent-ID = module.contos.managementgroup-parent-ID
}
module "platform" {
    source = "./modules/contos/platform"
    childgroupB0 = var.childgroupB0
    managementgroup-parent-ID = module.contos.managementgroup-parent-ID
    
}
module "connectivity" {
    source = "./modules/contos/platform/connectivity"
    childgroupB1 = var.childgroupB1
    childgroupB0-ID = module.platform.childgroupB0-ID
    
}
module "identity" {
    source = "./modules/contos/platform/identity"
    childgroupB3 = var.childgroupB3
    childgroupB0-ID = module.platform.childgroupB0-ID
}
module "management" {
    source = "./modules/contos/platform/management"
    childgroupB2 = var.childgroupB2
    childgroupB0-ID = module.platform.childgroupB0-ID
    
}
module "sandbox" {
    source = "./modules/contos/sandbox"
    childgroupC0 = var.childgroupC0
    managementgroup-parent-ID = module.contos.managementgroup-parent-ID
    
}
module "workloads" {
    source = "./modules/contos/workloads"
    childgroupD0 = var.childgroupD0
    managementgroup-parent-ID = module.contos.managementgroup-parent-ID
    
}
module "businessunit1" {
    source = "./modules/contos/workloads/bs1"
    childgroupD1 = var.childgroupD1
    childgroupD0-ID = module.workloads.childgroupD0-ID
    
}
module "businessunit2" {
    source = "./modules/contos/workloads/bs2"
    childgroupD2 = var.childgroupD2
    childgroupD0-ID = module.workloads.childgroupD0-ID
    
}

module "Security" {

  source = "./modules/contos/platform/connectivity/security"

  resource-group-name                   = var.resource-group-name
  location                              = var.location
  key_vault_name                        = var.key_vault_name
  soft_delete_retention_days            = var.soft_delete_retention_days
  purge_protection_enabled              = var.purge_protection_enabled
  sku_name                              = var.sku_name
  key_permissions                       = var.key_permissions
  secret_permissions                    = var.secret_permissions
  storage_permissions                   = var.storage_permissions
  secret1_name                          = var.secret1_name
  secret1_value                         = var.secret1_value
  secret2_name                          = var.secret2_name
  secret2_value                         = var.secret2_value
  secret3_name                          = var.secret3_name
  secret3_value                         = var.secret3_value
  secret4_name                          = var.secret4_name
  secret4_value                         = var.secret4_value
  object_id                             = var.object_id 
  depends_on                            = [module.resource-group]
}

module "resource-group" {
    source = "./modules/contos/platform/connectivity/ResourceGroup"
    resource-group-name = var.resource-group-name
    location = var.location
}

module "vnet" {
    source = "./modules/contos/platform/connectivity/Networking/ConnectivityServices/VirtualNetwork"
    vnet-name = var.vnet-name
    vnet-address-space = var.vnet-address-space
    resource-group-name = module.resource-group.resource-group-name
    location = module.resource-group.location
    vnet-subnet-name = var.vnet-subnet-name
    vnet-subnet-address_prefixes = var.vnet-subnet-address_prefixes

}

module "pip" {
    source = "./modules/contos/platform/connectivity/Networking/ApplicationServices/LoadBalancer"
    resource-group-name = module.resource-group.resource-group-name
    pip-name            = var.pip-name
    location            = module.resource-group.location
    pip-allocation_method = var.pip-allocation_method
    LB-name               = var.LB-name
    LB-FEIP-name          = var.LB-FEIP-name
    BEPool-name           = var.BEPool-name
    LBProbe-name          = var.LBProbe-name
    LBprobe-port          = var.LBprobe-port
    LBRule-name           = var.LBRule-name
    LBRule-protocol       = var.LBRule-protocol
    LBRule-frontend-port  = var.LBRule-frontend-port
    LBRule-backend-port   = var.LBRule-backend-port 
    NSG-name              = var.NSG-name
    NSR-name = var.NSR-name
    NSR-priority = var.NSR-priority
    NSR-direction = var.NSR-direction
    NSR-access = var.NSR-access
    NSR-protocol = var.NSR-protocol
    NSR-source_port_range = var.NSR-source_port_range
    NSR-destination_port_range = var.NSR-destination_port_range
    NSR-source_address_prefix = var.NSR-source_address_prefix
    NSR-destination_address_prefix = var.NSR-destination_address_prefix
}

module "APGWSUBNT" {
    source = "./modules/contos/platform/connectivity/Networking/ApplicationServices/ApplicationGateway"
    resource-group-name = module.resource-group.resource-group-name
    location = module.resource-group.location
    vnet-name = module.vnet.vnet-name
    APGWSUBNT-name = var.APGWSUBNT-name
    APGWSUBNT-address_prefixes = var.APGWSUBNT-address_prefixes
    pipAG-name = var.pipAG-name
    pipAG-allocation_method = var.pipAG-allocation_method
    pipAG-sku = var.pipAG-sku
    APGW-name = var.APGW-name
    APGW-sku-name = var.APGW-sku-name
    APGW-sku-tier = var.APGW-sku-tier
    APGW-sku-capacity = var.APGW-sku-capacity
    APGW-GIP-name = var.APGW-GIP-name
    APGW-FEPORT-name = var.APGW-FEPORT-name
    APGW-FEPORT-port = var.APGW-FEPORT-port
    APGW-FEIP-name = var.APGW-FEIP-name
    APGW-BEPOOL-name = var.APGW-BEPOOL-name
    APGW-BPST-name = var.APGW-BPST-name
    APGW-BPST-cookie_based_affinity = var.APGW-BPST-cookie_based_affinity
    APGW-BPST-port = var.APGW-BPST-port
    APGW-BPST-protocol = var.APGW-BPST-protocol
    APGW-BPST-request_timeout = var.APGW-BPST-request_timeout
    APGW-BPLS-name = var.APGW-BPLS-name
    APGW-BPLS-protocol = var.APGW-BPLS-protocol
    APGW-BPRR-name = var.APGW-BPRR-name
    APGW-BPRR-rule_type = var.APGW-BPRR-rule_type
    APGW-BPRR-priority = var.APGW-BPRR-priority

    firewall_policy_name = var.firewall_policy_name 
    firewall_policy_rule_collection_group_name = var.firewall_policy_rule_collection_group_name
    firewall_policy_rule_collection_group_priority = var.firewall_policy_rule_collection_group_priority
    app_rule_collection_name = var.app_rule_collection_name
    app_rule_collection_priority = var.app_rule_collection_priority
    app_rule_collection_action = var.app_rule_collection_action
    app_rule_collection_rule1 = var.app_rule_collection_rule1
    app_rule_collection_rule1_protocol1 = var.app_rule_collection_rule1_protocol1
    app_rule_collection_rule1_port1 = var.app_rule_collection_rule1_port1
    app_rule_collection_rule1_protocol2 = var.app_rule_collection_rule1_protocol2
    app_rule_collection_rule1_port2 = var.app_rule_collection_rule1_port2
    app_rule_collection_source_addresses = var.app_rule_collection_source_addresses
    app_rule_collection_destination_fqdns = var.app_rule_collection_destination_fqdns
    network_rule_collection_name = var.network_rule_collection_name
    network_rule_collection_priority = var.network_rule_collection_priority
    network_rule_collection_action = var.network_rule_collection_action
    network_rule_collection_rule1_name = var.network_rule_collection_rule1_name
    network_rule_collection_rule1_protocols = var.network_rule_collection_rule1_protocols
    network_rule_collection_rule1_source_addresses = var.network_rule_collection_rule1_source_addresses
    network_rule_collection_rule1_destination_addresses = var.network_rule_collection_rule1_destination_addresses
    network_rule_collection_rule1_destination_ports = var.network_rule_collection_rule1_destination_ports
    nat_rule_collection_rule_name = var.nat_rule_collection_rule_name
    nat_rule_collection_rule_priority = var.nat_rule_collection_rule_priority
    nat_rule_collection_rule_action = var.nat_rule_collection_rule_action
    nat_rule_collection_rule1_name = var.nat_rule_collection_rule1_name
    nat_rule_collection_rule1_protocols = var.nat_rule_collection_rule1_protocols
    nat_rule_collection_rule1_source_addresses = var.nat_rule_collection_rule1_source_addresses
    nat_rule_collection_rule1_destination_address = var.nat_rule_collection_rule1_destination_address
    nat_rule_collection_rule1_destination_ports = var.nat_rule_collection_rule1_destination_ports
    nat_rule_collection_rule1_translated_address = var.nat_rule_collection_rule1_translated_address
    nat_rule_collection_rule1_translated_port = var.nat_rule_collection_rule1_translated_port
}

module "BSTN-SB1" {
  source = "./modules/contos/platform/connectivity/Networking/ConnectivityServices/Bastion"
    resource-group-name = module.resource-group.resource-group-name
    location = module.resource-group.location
    vnet-name = module.vnet.vnet-name
    BSTN-SB1-name = var.BSTN-SB1-name
    BSTN-SB1-address_prefixes = var.BSTN-SB1-address_prefixes
    BSTN-pip-name = var.BSTN-pip-name
    BSTN-pip-allocation_method = var.BSTN-pip-allocation_method
    BSTN-pip-sku = var.BSTN-pip-sku
    BHOST-name = var.BHOST-name
    BHOST-ip-name = var.BHOST-ip-name
}
module "frontdoor" {
    source = "./modules/contos/platform/connectivity/Networking/ApplicationServices/FrontDoor"
    resource-group-name = module.resource-group.resource-group-name
    frontdoor-name = var.frontdoor-name
    frontdoor-RR-name = var.frontdoor-RR-name
    frontdoor-RR-accepted_protocols = var.frontdoor-RR-accepted_protocols
    frontdoor-RR-patterns_to_match = var.frontdoor-RR-patterns_to_match
    frontdoor-RR-frontend_endpoints = var.frontdoor-RR-frontend_endpoints
    frontdoor-RR-forwarding_protocol = var.frontdoor-RR-forwarding_protocol
    frontdoor-RR-backend_pool_name = var.frontdoor-RR-backend_pool_name
    frontdoor-BPLB-name = var.frontdoor-BPLB-name
    frontdoor-BPHP-name = var.frontdoor-BPHP-name
    frontdoor-BP-name = var.frontdoor-BP-name
    frontdoor-backend-host_header = var.frontdoor-backend-host_header
    frontdoor-backend-address = var.frontdoor-backend-address
    frontdoor-backend-http_port = var.frontdoor-backend-http_port
    frontdoor-backend-https_port = var.frontdoor-backend-https_port
    frontdoor-backend-load_balancing_name = var.frontdoor-backend-load_balancing_name
    frontdoor-backend-health_probe_name = var.frontdoor-backend-health_probe_name
    frontdoor-FE-name = var.frontdoor-FE-name
    frontdoor-FE-host_name = var.frontdoor-FE-host_name
    frontdoor-FE-session_affinity_enabled = var.frontdoor-FE-session_affinity_enabled
    frontdoor-FE-session_affinity_ttl_seconds = var.frontdoor-FE-session_affinity_ttl_seconds
}


module "resource-group2" {
    source = "./modules/contos/platform/connectivity/ResourceGroup2"
    resource-group2-name = var.resource-group2-name
    location2 = var.location2
}

module "vnet2" {
    source = "./modules/contos/platform/connectivity/Networking/ConnectivityServices/VirtualNetwork2"
    vnet2-name = var.vnet2-name
    vnet2-address-space = var.vnet2-address-space
    resource-group2-name = module.resource-group2.resource-group2-name
    location2 = module.resource-group2.location2
    vnet2-subnet2-name = var.vnet2-subnet2-name
    vnet2-subnet2-address_prefixes = var.vnet2-subnet2-address_prefixes

}

module "Nat-SB" {
  source = "./modules/contos/platform/connectivity/Networking/ConnectivityServices/NAT"
    resource-group2-name = module.resource-group2.resource-group2-name
    location2 = module.resource-group2.location2
    vnet2-name = module.vnet2.vnet2-name
    Nat-SB-name = var.Nat-SB-name
    Nat-SB-address_prefixes = var.Nat-SB-address_prefixes
    NAT-pip-name = var.NAT-pip-name
    NAT-pip-allocation_method = var.NAT-pip-allocation_method
    NAT-pip-sku = var.NAT-pip-sku
    NAT-GWY-name = var.NAT-GWY-name
    NAT-GWY-sku_name = var.NAT-GWY-sku_name
}

module "TF-PIP" {
  source = "./modules/contos/platform/connectivity/Networking/ApplicationServices/TrafficManager"
  resource-group2-name = module.resource-group2.resource-group2-name
  location2 = module.resource-group2.location2
  TF-PIP-name = var.TF-PIP-name
  TF-PIP-allocation_method = var.TF-PIP-allocation_method
  TF-PIP-domain_name_label = var.TF-PIP-domain_name_label
  TF-Profile-name = var.TF-Profile-name
  TF-Profile-traffic_routing_method = var.TF-Profile-traffic_routing_method
  TF-Profile-relative_name = var.TF-Profile-relative_name
  TF-Profile-ttl = var.TF-Profile-ttl
  TF-Profile-protocol = var.TF-Profile-protocol
  TF-Profile-port = var.TF-Profile-port
  TF-Profile-path = var.TF-Profile-path
  TF-Profile-interval_in_seconds = var.TF-Profile-interval_in_seconds
  TF-Profile-timeout_in_seconds = var.TF-Profile-timeout_in_seconds
  TF-Profile-tolerated_number_of_failures = var.TF-Profile-tolerated_number_of_failures
  TF-endpoint-name = var.TF-endpoint-name
  TF-endpoint-weight = var.TF-endpoint-weight
}

module "PTS-sb" {
  source = "./modules/contos/platform/connectivity/Networking/ConnectivityServices/PointToSiteVpn"
  resource-group2-name = module.resource-group2.resource-group2-name
  location2 = module.resource-group2.location2
  vnet2-name = module.vnet2.vnet2-name
  PTS-sb-name = var.PTS-sb-name 
  PTS-sb-address_prefixes = var.PTS-sb-address_prefixes
  PTS-LNGonpremise-name = var.PTS-LNGonpremise-name
  PTS-LNGonpremise-gateway_address = var.PTS-LNGonpremise-gateway_address
  PTS-LNGonpremise-address_space = var.PTS-LNGonpremise-address_space
  PTS-pip-name = var.PTS-pip-name
  PTS-pip-allocation_method = var.PTS-pip-allocation_method
  PTS-VNG-name = var.PTS-VNG-name
  PTS-VNG-type = var.PTS-VNG-type
  PTS-VNG-vpn_type = var.PTS-VNG-vpn_type 
  PTS-VNG-active_active = var.PTS-VNG-active_active
  PTS-VNG-enable_bgp = var.PTS-VNG-enable_bgp
  PTS-VNG-sku = var.PTS-VNG-sku
  PTS-VNG-ipc-private_ip_address_allocation = var.PTS-VNG-ipc-private_ip_address_allocation
  PTS-VNGC-name = var.PTS-VNGC-name
  PTS-VNGC-type = var.PTS-VNGC-type
  PTS-VNGC-shared_key = var.PTS-VNGC-shared_key 
}

