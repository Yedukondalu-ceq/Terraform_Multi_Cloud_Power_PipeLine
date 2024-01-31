# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

provider "azurerm" {
  features {}

  subscription_id = "42d4d8d0-34a5-4419-80b1-3f6e452e94eb"
}

resource "azurerm_virtual_network" "ren-vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "ren-subnet" {
  name                 = "ren-linux-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.ren-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "ren-nic" {
  count               = var.vm_count
  name                = "ren-linux-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ren-linux-internal-${count.index}"
    subnet_id                     = azurerm_subnet.ren-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ren-linux-VM" {
  count                           = var.vm_count
  name                            = "renaissance-vm-${count.index}"
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "renaissanceuser"
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ren-nic[count.index].id, ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
