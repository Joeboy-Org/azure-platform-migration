resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}


resource "azurerm_key_vault" "main" {
  name                      = "kv-${var.environment}-${random_string.keyvault_suffix.result}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
  purge_protection_enabled  = false
}