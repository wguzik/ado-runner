output "vm_public_ip" {
  description = "The public IP address of the virtual machine"
  value       = module.vm.public_ip_address
  sensitive   = true
}

output "get_vm_password_command" {
  description = "Azure CLI command to fetch the VM password"
  value       = "az keyvault secret show --name ${module.vm.password_secret_name} --vault-name ${local.resource_names.key_vault} --query 'value' -o tsv"
}
