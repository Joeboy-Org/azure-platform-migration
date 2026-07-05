locals {
  routes = csvdecode(file("${path.module}/routes.csv"))
}

resource "azurerm_route_table" "custom" {
  name                = "rt-custom-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_route" "routes" {
  for_each = { for r in local.routes : r.name => r }

  name                   = each.value.name
  resource_group_name    = azurerm_resource_group.main.name
  route_table_name       = azurerm_route_table.custom.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip : null
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.custom.id
}

resource "azurerm_subnet_route_table_association" "data" {
  subnet_id      = azurerm_subnet.data.id
  route_table_id = azurerm_route_table.custom.id
}
