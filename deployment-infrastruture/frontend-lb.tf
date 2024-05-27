resource "azurerm_lb" "frontend" {
  name                = "frontend-lb"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontendpublicIPAddress"
    public_ip_address_id = azurerm_public_ip.frontend.id
  }
  depends_on = [ azurerm_public_ip.frontend,azurerm_container_group.frontend1,azurerm_container_group.frontend2 ]
}

resource "azurerm_lb_backend_address_pool" "frontend" {
  loadbalancer_id = azurerm_lb.frontend.id
  name            = "frontend-pool"
  depends_on = [ azurerm_lb.frontend ]
}

resource "azurerm_lb_probe" "frontend_http_probe" {
  loadbalancer_id = azurerm_lb.frontend.id
  name            = "http"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
  depends_on = [ azurerm_lb.frontend ]
}

# Duplicate following two blocks and change to 443/https for secure traffic

resource "azurerm_lb_rule" "proxy" {
  loadbalancer_id                = azurerm_lb.frontend.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontendpublicIPAddress"
  probe_id                       = azurerm_lb_probe.frontend_http_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.frontend.id]
  disable_outbound_snat          = true
  depends_on = [ azurerm_lb_backend_address_pool_address.container-3, azurerm_lb_backend_address_pool_address.container-4 ]
}

resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontendallowInternetzTraffic"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location

  security_rule {
    name                       = "allow_http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "80"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_subnet.frontend ]
}

resource "azurerm_subnet_network_security_group_association" "frontend-proxy" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
  depends_on = [ azurerm_network_security_group.frontend_nsg ]
}
resource "azurerm_lb_backend_address_pool_address" "container-3" {
  name                    = "container-3"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend.id
  virtual_network_id      = azurerm_virtual_network.proxy.id
  ip_address              = azurerm_container_group.frontend1.ip_address
  depends_on = [ azurerm_container_group.frontend1, azurerm_lb_backend_address_pool.frontend ]
}
resource "azurerm_lb_backend_address_pool_address" "container-4" {
  name                    = "container-4"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend.id
  virtual_network_id      = azurerm_virtual_network.proxy.id
  ip_address              = azurerm_container_group.frontend2.ip_address
  depends_on = [ azurerm_container_group.frontend2, azurerm_lb_backend_address_pool.frontend ]
}