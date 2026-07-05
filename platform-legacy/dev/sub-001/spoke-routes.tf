locals {
  spoke_route_csvs = {
    "rt-spoke1-web"  = csvdecode(file("${path.module}/routes/spoke1-web.csv"))
    "rt-spoke1-app"  = csvdecode(file("${path.module}/routes/spoke1-app.csv"))
    "rt-spoke1-data" = csvdecode(file("${path.module}/routes/spoke1-data.csv"))
    "rt-spoke2-web"  = csvdecode(file("${path.module}/routes/spoke2-web.csv"))
    "rt-spoke2-app"  = csvdecode(file("${path.module}/routes/spoke2-app.csv"))
    "rt-spoke2-data" = csvdecode(file("${path.module}/routes/spoke2-data.csv"))
  }
}

resource "azurerm_route_table" "spokes" {
  for_each            = local.spoke_route_csvs
  name                = "${each.key}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_route" "spokes" {
  for_each = merge([
    for rt_name, routes in local.spoke_route_csvs : {
      for r in routes : "${rt_name}--${r.name}" => merge(r, { rt_name = rt_name })
    }
  ]...)

  name                   = each.value.name
  resource_group_name    = azurerm_resource_group.main.name
  route_table_name       = azurerm_route_table.spokes[each.value.rt_name].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip : null
}

resource "azurerm_subnet_route_table_association" "spoke1_web" {
  subnet_id      = azurerm_subnet.spoke1_web.id
  route_table_id = azurerm_route_table.spokes["rt-spoke1-web"].id
}

resource "azurerm_subnet_route_table_association" "spoke1_app" {
  subnet_id      = azurerm_subnet.spoke1_app.id
  route_table_id = azurerm_route_table.spokes["rt-spoke1-app"].id
}

resource "azurerm_subnet_route_table_association" "spoke1_data" {
  subnet_id      = azurerm_subnet.spoke1_data.id
  route_table_id = azurerm_route_table.spokes["rt-spoke1-data"].id
}

resource "azurerm_subnet_route_table_association" "spoke2_web" {
  subnet_id      = azurerm_subnet.spoke2_web.id
  route_table_id = azurerm_route_table.spokes["rt-spoke2-web"].id
}

resource "azurerm_subnet_route_table_association" "spoke2_app" {
  subnet_id      = azurerm_subnet.spoke2_app.id
  route_table_id = azurerm_route_table.spokes["rt-spoke2-app"].id
}

resource "azurerm_subnet_route_table_association" "spoke2_data" {
  subnet_id      = azurerm_subnet.spoke2_data.id
  route_table_id = azurerm_route_table.spokes["rt-spoke2-data"].id
}
