locals {
  remote_access_users_map = { for idx, val in var.users : val => idx }
}

# moved {
#   from = azuread_group_member.remote_access_memebership[0]
#   to   = azuread_group_member.remote_access_memebership["Josephokorie32_gmail.com#EXT#@mayorbamgboyegmail.onmicrosoft.com"]
# }

data "azuread_client_config" "current" {}

resource "azuread_group" "remote_access_users" {
  display_name     = "${var.environment}-remote-access-users"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "remote_access_memebership" {
  for_each         = local.remote_access_users_map
  group_object_id  = azuread_group.remote_access_users.object_id
  member_object_id = data.azuread_user.users[each.key].object_id
}

data "azuread_user" "users" {
  for_each            = local.remote_access_users_map
  user_principal_name = each.key
}