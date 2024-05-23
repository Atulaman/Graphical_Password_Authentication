resource "azurerm_firewall_policy_rule_collection_group" "gpa" {
  name               = "gpa-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.GPA-fwpolicy.id
  priority           = 100
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 300
    action   = "Allow"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      /*protocols {
        type = "Https"
        port = 443
      }*/
      source_addresses  = ["*"]
      destination_fqdns = [azurerm_public_ip.frontend.ip_address]
      #destination_addresses = [ azurerm_public_ip.frontend.ip_address ]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 200
    action   = "Allow"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = [azurerm_public_ip.frontend.ip_address]
      destination_ports     = ["80"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 100
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.firewall.ip_address
      destination_ports   = ["80"]
      translated_address  = azurerm_public_ip.frontend.ip_address
      translated_port     = "80"
    }
  }
}