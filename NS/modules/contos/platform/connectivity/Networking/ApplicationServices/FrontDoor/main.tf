    
resource "azurerm_frontdoor" "frontdoor" {
  name                                         = var.frontdoor-name
  resource_group_name                          = var.resource-group-name
  

  routing_rule {
    name               = var.frontdoor-RR-name
    accepted_protocols = var.frontdoor-RR-accepted_protocols
    patterns_to_match  = var.frontdoor-RR-patterns_to_match
    frontend_endpoints = var.frontdoor-RR-frontend_endpoints

    forwarding_configuration {
      forwarding_protocol = var.frontdoor-RR-forwarding_protocol
      backend_pool_name   = var.frontdoor-RR-backend_pool_name
    }
  }

  backend_pool_load_balancing {
    name = var.frontdoor-BPLB-name
  }

  backend_pool_health_probe {
    name    = var.frontdoor-BPHP-name
    
  }

  backend_pool {
    name = var.frontdoor-BP-name

    backend {
      host_header = var.frontdoor-backend-host_header
      address     = var.frontdoor-backend-address
      http_port   = var.frontdoor-backend-http_port
      https_port  = var.frontdoor-backend-https_port
    }

    load_balancing_name = var.frontdoor-backend-load_balancing_name
    health_probe_name   = var.frontdoor-backend-health_probe_name
  }

  frontend_endpoint {
    name      = var.frontdoor-FE-name
    host_name = var.frontdoor-FE-host_name
    session_affinity_enabled = var.frontdoor-FE-session_affinity_enabled
    session_affinity_ttl_seconds = var.frontdoor-FE-session_affinity_ttl_seconds
  }
}