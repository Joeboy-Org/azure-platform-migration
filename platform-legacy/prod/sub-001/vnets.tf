resource "azurerm_virtual_network" "shared" {
  name                = "vnet-shared-${var.environment}"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "shared_dns" {
  name                 = "subnet-dns"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "shared_auth" {
  name                 = "subnet-auth"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.2.2.0/24"]
}

resource "azurerm_subnet" "shared_monitoring" {
  name                 = "subnet-monitoring"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.2.3.0/24"]
}

resource "azurerm_virtual_network" "dmz" {
  name                = "vnet-dmz-${var.environment}"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "dmz_public" {
  name                 = "subnet-public"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = ["10.3.1.0/24"]
}

resource "azurerm_subnet" "dmz_waf" {
  name                 = "subnet-waf"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = ["10.3.2.0/24"]
}

resource "azurerm_subnet" "dmz_proxy" {
  name                 = "subnet-proxy"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = ["10.3.3.0/24"]
}

resource "azurerm_virtual_network" "mgmt" {
  name                = "vnet-mgmt-${var.environment}"
  address_space       = ["10.4.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "mgmt_jumpbox" {
  name                 = "subnet-jumpbox"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = ["10.4.1.0/24"]
}

resource "azurerm_subnet" "mgmt_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = ["10.4.2.0/24"]
}

resource "azurerm_subnet" "mgmt_monitoring" {
  name                 = "subnet-monitoring"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = ["10.4.3.0/24"]
}

resource "azurerm_virtual_network" "dr" {
  name                = "vnet-dr-${var.environment}"
  address_space       = ["10.5.0.0/16"]
  location            = "East US 2"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "dr_web" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dr.name
  address_prefixes     = ["10.5.1.0/24"]
}

resource "azurerm_subnet" "dr_app" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dr.name
  address_prefixes     = ["10.5.2.0/24"]
}

resource "azurerm_subnet" "dr_data" {
  name                 = "subnet-data"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.dr.name
  address_prefixes     = ["10.5.3.0/24"]
}
