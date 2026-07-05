locals {
  route_table_csvs = {
    "rt-main-web"     = csvdecode(file("${path.module}/routes/main-web.csv"))
    "rt-main-app"     = csvdecode(file("${path.module}/routes/main-app.csv"))
    "rt-main-data"    = csvdecode(file("${path.module}/routes/main-data.csv"))
    "rt-shared-dns"   = csvdecode(file("${path.module}/routes/shared-dns.csv"))
    "rt-shared-auth"  = csvdecode(file("${path.module}/routes/shared-auth.csv"))
    "rt-shared-mon"   = csvdecode(file("${path.module}/routes/shared-monitoring.csv"))
    "rt-dmz-public"   = csvdecode(file("${path.module}/routes/dmz-public.csv"))
    "rt-dmz-waf"      = csvdecode(file("${path.module}/routes/dmz-waf.csv"))
    "rt-dmz-proxy"    = csvdecode(file("${path.module}/routes/dmz-proxy.csv"))
    "rt-mgmt-jumpbox" = csvdecode(file("${path.module}/routes/mgmt-jumpbox.csv"))
    "rt-mgmt-bastion" = csvdecode(file("${path.module}/routes/mgmt-bastion.csv"))
    "rt-mgmt-mon"     = csvdecode(file("${path.module}/routes/mgmt-monitoring.csv"))
    "rt-dr-web"       = csvdecode(file("${path.module}/routes/dr-web.csv"))
    "rt-dr-app"       = csvdecode(file("${path.module}/routes/dr-app.csv"))
    "rt-dr-data"      = csvdecode(file("${path.module}/routes/dr-data.csv"))
  }
}

resource "azurerm_route_table" "subnets" {
  for_each            = local.route_table_csvs
  name                = each.key
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_route" "subnets" {
  for_each = merge([
    for rt_name, routes in local.route_table_csvs : {
      for r in routes : "${rt_name}--${r.name}" => merge(r, { rt_name = rt_name })
    }
  ]...)

  name                   = each.value.name
  resource_group_name    = azurerm_resource_group.main.name
  route_table_name       = azurerm_route_table.subnets[each.value.rt_name].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip : null
}

resource "azurerm_subnet_route_table_association" "main_web" {
  subnet_id      = azurerm_subnet.web.id
  route_table_id = azurerm_route_table.subnets["rt-main-web"].id
}

resource "azurerm_subnet_route_table_association" "main_app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.subnets["rt-main-app"].id
}

resource "azurerm_subnet_route_table_association" "main_data" {
  subnet_id      = azurerm_subnet.data.id
  route_table_id = azurerm_route_table.subnets["rt-main-data"].id
}

resource "azurerm_subnet_route_table_association" "shared_dns" {
  subnet_id      = azurerm_subnet.shared_dns.id
  route_table_id = azurerm_route_table.subnets["rt-shared-dns"].id
}

resource "azurerm_subnet_route_table_association" "shared_auth" {
  subnet_id      = azurerm_subnet.shared_auth.id
  route_table_id = azurerm_route_table.subnets["rt-shared-auth"].id
}

resource "azurerm_subnet_route_table_association" "shared_monitoring" {
  subnet_id      = azurerm_subnet.shared_monitoring.id
  route_table_id = azurerm_route_table.subnets["rt-shared-mon"].id
}

resource "azurerm_subnet_route_table_association" "dmz_public" {
  subnet_id      = azurerm_subnet.dmz_public.id
  route_table_id = azurerm_route_table.subnets["rt-dmz-public"].id
}

resource "azurerm_subnet_route_table_association" "dmz_waf" {
  subnet_id      = azurerm_subnet.dmz_waf.id
  route_table_id = azurerm_route_table.subnets["rt-dmz-waf"].id
}

resource "azurerm_subnet_route_table_association" "dmz_proxy" {
  subnet_id      = azurerm_subnet.dmz_proxy.id
  route_table_id = azurerm_route_table.subnets["rt-dmz-proxy"].id
}

resource "azurerm_subnet_route_table_association" "mgmt_jumpbox" {
  subnet_id      = azurerm_subnet.mgmt_jumpbox.id
  route_table_id = azurerm_route_table.subnets["rt-mgmt-jumpbox"].id
}

resource "azurerm_subnet_route_table_association" "mgmt_bastion" {
  subnet_id      = azurerm_subnet.mgmt_bastion.id
  route_table_id = azurerm_route_table.subnets["rt-mgmt-bastion"].id
}

resource "azurerm_subnet_route_table_association" "mgmt_monitoring" {
  subnet_id      = azurerm_subnet.mgmt_monitoring.id
  route_table_id = azurerm_route_table.subnets["rt-mgmt-mon"].id
}

resource "azurerm_subnet_route_table_association" "dr_web" {
  subnet_id      = azurerm_subnet.dr_web.id
  route_table_id = azurerm_route_table.subnets["rt-dr-web"].id
}

resource "azurerm_subnet_route_table_association" "dr_app" {
  subnet_id      = azurerm_subnet.dr_app.id
  route_table_id = azurerm_route_table.subnets["rt-dr-app"].id
}

resource "azurerm_subnet_route_table_association" "dr_data" {
  subnet_id      = azurerm_subnet.dr_data.id
  route_table_id = azurerm_route_table.subnets["rt-dr-data"].id
}
