terraform {
  backend "azurerm" {
    subscription_id      = "ee2efe34-cc9e-44b4-964f-dc168b2ed7bd"
    resource_group_name  = "rg-tfstate-mgmt"
    storage_account_name = "1jaaeb7idi8ir07w"
    container_name       = "platform-dev"
    key                  = "sub-001.terraform.tfstate"
  }
}