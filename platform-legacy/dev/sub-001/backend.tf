terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    subscription_id      = "ee2efe34-cc9e-44b4-964f-dc168b2ed7bd"
    resource_group_name  = "rg-tfstate-mgmt"
    storage_account_name = "1jaaeb7idi8ir07w"
    container_name       = "legacy-dev"
    key                  = "sub-001.terraform.tfstate"
  }
}
