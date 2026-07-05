terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mgmt"
    storage_account_name = "1jaaeb7idi8ir07w"
    container_name       = "legacy-dev"
    key                  = "sub-001.terraform.tfstate"
  }
}
