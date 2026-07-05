resource "azurerm_role_assignment" "sp" {
  count                = length(local.key_vault_roles)
  scope                = azurerm_key_vault.main.id
  role_definition_name = element(local.key_vault_roles, count.index)
  principal_id         = data.azurerm_client_config.current.object_id #current environment's managed identity
}

resource "azurerm_role_assignment" "linux_entra_id_user_login" {
  scope                = azurerm_linux_virtual_machine.main.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_group.remote_access_users.object_id #data.azurerm_client_config.current.object_id #object id of user
}

resource "azurerm_role_assignment" "windows_entra_id_user_login" {
  scope                = azurerm_windows_virtual_machine.main.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_group.remote_access_users.object_id #data.azurerm_client_config.current.object_id #object id of user
}