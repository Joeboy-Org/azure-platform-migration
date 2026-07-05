terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mgmt"
    storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME"
    container_name       = "platform-dev"
    key                  = "sub-001.terraform.tfstate"
  }
}