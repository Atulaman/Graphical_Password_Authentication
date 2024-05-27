resource "azurerm_lb" "proxy" {
  name                = "proxy-lb"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.proxy.id
  }
  depends_on = [ azurerm_public_ip.proxy,azurerm_container_group.backend1,azurerm_container_group.backend2 ]
}

resource "azurerm_lb_backend_address_pool" "proxy" {
  loadbalancer_id = azurerm_lb.proxy.id
  name            = "proxy-pool"
  depends_on = [ azurerm_lb.proxy ]
}

resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.proxy.id
  name            = "http"
  port            = 3003
  protocol        = "Http"
  request_path    = "/"
  depends_on = [ azurerm_lb.proxy ]
}

# Duplicate following two blocks and change to 443/https for secure traffic

resource "azurerm_lb_rule" "proxy_80" {
  loadbalancer_id                = azurerm_lb.proxy.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 3003
  backend_port                   = 3003
  frontend_ip_configuration_name = "publicIPAddress"
  probe_id                       = azurerm_lb_probe.http_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.proxy.id]
  disable_outbound_snat          = true
  depends_on = [ azurerm_lb_backend_address_pool_address.container-1, azurerm_lb_backend_address_pool_address.container-2 ]
}
resource "azurerm_lb_nat_rule" "proxy_80" {
  name = "test_pool"
  resource_group_name            = azurerm_resource_group.GPA.name
  loadbalancer_id                = azurerm_lb.proxy.id
  protocol                       = "Tcp"
  frontend_port_start = 80
  frontend_port_end = 81
 # frontend_port                  = 80
  backend_port                   = 3003
  frontend_ip_configuration_name = "publicIPAddress"
  idle_timeout_in_minutes        = 4
  backend_address_pool_id = azurerm_lb_backend_address_pool.proxy.id
  depends_on = [ azurerm_lb_backend_address_pool_address.container-1, azurerm_lb_backend_address_pool_address.container-2 ]
}
resource "azurerm_network_security_group" "proxy" {
  name                = "allowInternetzTraffic"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location

  security_rule {
    name                       = "allow_http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "3003"
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
  depends_on = [ azurerm_subnet.proxy]
}

resource "azurerm_subnet_network_security_group_association" "proxy" {
  subnet_id                 = azurerm_subnet.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
  depends_on = [ azurerm_network_security_group.proxy ]
}
resource "azurerm_lb_backend_address_pool_address" "container-1" {
  name                    = "container-1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.proxy.id
  virtual_network_id      = azurerm_virtual_network.proxy.id
  ip_address              = azurerm_container_group.backend1.ip_address
  depends_on = [ azurerm_container_group.backend1, azurerm_lb_backend_address_pool.proxy ]
}
resource "azurerm_lb_backend_address_pool_address" "container-2" {
  name                    = "container-2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.proxy.id
  virtual_network_id      = azurerm_virtual_network.proxy.id
  ip_address              = azurerm_container_group.backend2.ip_address
  depends_on = [ azurerm_container_group.backend2, azurerm_lb_backend_address_pool.proxy ]
}