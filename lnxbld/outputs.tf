output "lnx_name" {
  value = { for vm in azurerm_linux_virtual_machine.sec-lnx1 : "${vm.name}" => vm.id }
}
output "private_ip_addresses" {
  value = azurerm_network_interface.sec-nic[*].private_ip_address
}
