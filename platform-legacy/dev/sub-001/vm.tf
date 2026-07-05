resource "tls_private_key" "linux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Store the ssh key in key vault secrets
resource "azurerm_key_vault_secret" "linux_private" {
  name         = "linuxvm-ssh-private-${var.environment}"
  value        = tls_private_key.linux.private_key_pem
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "linux_public" {
  name         = "linuxvm-ssh-public-${var.environment}"
  value        = tls_private_key.linux.public_key_openssh
  key_vault_id = azurerm_key_vault.main.id
}

#Store the password in key vault secrets
resource "azurerm_key_vault_secret" "windows_private" {
  name         = "windows-private-password-${var.environment}"
  value        = var.windows_vm_admin_password
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_public_ip" "linux" {
  name                = "pip-linux-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "linux" {
  name                = "nic-linux-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux.id
  }
}

resource "azurerm_network_interface_security_group_association" "linux" {
  network_interface_id      = azurerm_network_interface.linux.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "vm-linux-${var.environment}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.linux.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.linux.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "linux_entra_id_login" {
  name                       = "${azurerm_linux_virtual_machine.main.name}-AADSSHLogin"
  virtual_machine_id         = azurerm_linux_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# resource "azurerm_public_ip" "windows" {
#   name                = "pip-windows-${var.environment}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

resource "azurerm_network_interface" "windows" {
  name                = "nic-windows-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "windows" {
  network_interface_id      = azurerm_network_interface.windows.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "vm-win-${var.environment}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_D2s_v3"
  admin_username        = var.vm_admin_username
  admin_password        = var.windows_vm_admin_password
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "windows_entra_id_login" {
  name                       = "${azurerm_windows_virtual_machine.main.name}-AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}