resource "azurerm_virtual_network" "spoke1" {
  name                = "vnet-spoke1-${var.environment}"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "spoke1_web" {
  name                 = "subnet-web-spoke1-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "spoke1_app" {
  name                 = "subnet-app-spoke1-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.2.2.0/24"]
}

resource "azurerm_subnet" "spoke1_data" {
  name                 = "subnet-data-spoke1-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.2.3.0/24"]
}

resource "azurerm_virtual_network" "spoke2" {
  name                = "vnet-spoke2-${var.environment}"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "spoke2_web" {
  name                 = "subnet-web-spoke2-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.3.1.0/24"]
}

resource "azurerm_subnet" "spoke2_app" {
  name                 = "subnet-app-spoke2-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.3.2.0/24"]
}

resource "azurerm_subnet" "spoke2_data" {
  name                 = "subnet-data-spoke2-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.3.3.0/24"]
}
