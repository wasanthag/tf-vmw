# Key Outputs

# App1 Server IP
output "App1_Server_Public_IP" {
  value = vsphere_virtual_machine.app1.default_ip_address
}
# windows Server IP
output "Windows_Server_Public_IP" {
  value = vsphere_virtual_machine.win2016-vm.default_ip_address
}

