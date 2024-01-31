output "NIC-id" {
  value = azurerm_network_interface.ren-nic[*].id
}
